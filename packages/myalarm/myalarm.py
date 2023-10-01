#!/usr/bin/env python

import argparse

from functools import partial
from math import floor
from random import choice
from tendo import singleton
from threading import Thread
from tkinter import IntVar, messagebox, Tk
from tkinter.ttk import Button, Frame, Label, Progressbar, Style

from pydbus import SystemBus


def make_fullscreen(screen: Tk) -> None:
    screen.attributes('-fullscreen', True)


def make_topmost(screen: Tk) -> None:
    screen.lift()
    screen.attributes("-topmost", True)


def not_topmost(screen: Tk) -> None:
    screen.attributes("-topmost", False)


def quit_app() -> None:
    global root_running, timer_running

    if demo or valid_quit:
        if timer_running:
            timer.destroy()
            timer_running = False
        if root_running:
            root.destroy()
            root_running = False
        exit()


def shutdown_process() -> None:
    if shut_down_now:
        bus = SystemBus()
        proxy = bus.get(
            'org.freedesktop.login1',
            '/org/freedesktop/login1',
        )
        if proxy.CanPowerOff() == 'yes':
            proxy.PowerOff(False)


def shutdown_timer() -> None:
    global root_running, timer_running

    if root_running:
        root.destroy()
    root_running = False
    timer.deiconify()
    timer.start_countdown()
    timer_running = True


class App(Tk):
    buttons: dict = {}
    last_button: int = 0
    main_frame: Frame
    rows: dict = {
        1: [0, 1, 2, 3, 4, 5],
        2: [0, 1, 2, 3, 4, 5],
        3: [0, 1, 2, 3, 4, 5],
        4: [0, 1, 2, 3, 4, 5],
        5: [0, 1, 2, 3, 4, 5],
    }

    def __init__(self) -> None:
        global app_font_tuple, demo, message, root_running, timer

        Tk.__init__(self)
        s = Style(self)
        s.theme_use('clam')
        self.title("ALARM")
        self.main_frame = Frame(self, padding="3 3 12 12")
        self.main_frame.grid(sticky="NESW")
        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)
        for number in range(6):
            self.main_frame.columnconfigure(number, weight=1)
            # if number < 5:
            self.main_frame.rowconfigure(
                number,
                weight=1 if number > 0 else 2,
            )
        message_frame = Frame(self.main_frame, padding="3 3 12 12")
        message_frame.grid(column=0, row=0, columnspan=5)
        Label(
            message_frame,
            text=message,
            justify='center',
            font=app_font_tuple,
        ).grid(
            row=0,
            column=0,
        )
        button_shutdown = Button(
            message_frame,
            text="Shutdown",
            command=partial(self._call_button, 99),
        )
        button_shutdown.grid(column=0, row=1)
        make_topmost(self)
        if not demo:
            make_fullscreen(self)

        for number in range(30, 0, -1):
            row, columns = choice(list(self.rows.items()))
            column = choice(columns)
            self.rows[row].remove(column)
            if len(self.rows[row]) == 0:
                self.rows.pop(row)
            self.buttons.update(
                {
                    number: Button(
                        self.main_frame,
                        text=number,
                        command=partial(self._call_button, number),
                    )
                }
            )
            self.buttons[number].grid(row=row, column=column, sticky="N E S W")
        self.focus()

        self.protocol("WM_DELETE_WINDOW", self._on_exit)
        root_running = True

    def _call_button(self, button: int) -> None:
        global demo, shut_down, valid_quit

        if button == 99:
            shut_down = True
            self._on_exit()
            return
        if (demo and button == 30) or (self.last_button == 29 and button == 30):
            valid_quit = True
            self._on_exit()
            return
        if button == self.last_button + 1:
            self.last_button = button

    def _on_exit(self) -> None:
        global shut_down, valid_quit

        not_topmost(self)
        if valid_quit:
            quit_app()
            return
        if shut_down:
            if messagebox.askokcancel(
                'Shutdown',
                ' '.join(
                    [
                        'If you press OK, the computer will give you 1 minute',
                        'to save and then will shut down.',
                    ]
                ),
            ):
                shutdown_timer()
                return
            shut_down = False
        make_topmost(self)


class TimerWindow(Tk):
    clock: Label
    count: bool = True
    countdown: Progressbar
    f: Frame
    s: Style
    timer: IntVar
    timer_thread: Thread

    def __init__(self):
        global font_tuple

        Tk.__init__(self)
        self.s = Style(self)
        self.s.theme_use('clam')
        f = Frame(self)
        f.pack(fill='both')
        self.timer = IntVar(f, 60)
        self.clock = Label(f, textvariable=self.timer, font=font_tuple)
        self.clock.grid(row=0, column=1, sticky="NESW")
        self.countdown = Progressbar(
            f,
            maximum=60.0,
            variable=self.timer,
        )
        self.countdown.grid(row=0, column=0)
        make_topmost(self)
        w = self.winfo_width()
        h = self.winfo_height()
        ws = self.winfo_screenwidth()
        hs = self.winfo_screenheight()
        x = floor((ws / 2) - (w / 2))
        y = floor((hs / 2) - (h / 2))
        self.geometry(f'+{x}+{y}')
        self.overrideredirect(True)
        self.after(1000, self.withdraw)

        self.protocol("WM_DELETE_WINDOW", quit_app)

    def _on_complete(self) -> None:
        global demo, shut_down_now

        if demo:
            quit_app()
        shut_down_now = True
        shutdown_process()

    def start_countdown(self) -> None:
        self.after(1000, self._timer_count)

    def _timer_count(self):
        if self.timer.get() > 0 and self.count:
            self.timer.set(self.timer.get() - 1)
            self.after(1000, self._timer_count)
            return
        self._on_complete()


app_font_tuple = ("FiraCode Nerd Font", 50, "bold")
demo: bool = False
font_tuple = ("FiraCode Nerd Font", 50, "bold")
message: str = ""
root: App
root_running: bool = False
shut_down: bool = False
shut_down_now: bool = False
timer: TimerWindow
timer_running: bool = False
valid_quit: bool = False

if __name__ == '__main__':
    me = singleton.SingleInstance()
    parser = argparse.ArgumentParser(
        'myalarm',
        description=' '.join(
            [
                'Basic alarm interface to take over the screen and block the',
                'user from moving forward without acknowledging the alarm.',
            ]
        ),
    )
    parser.add_argument(
        'message',
        help='Message to display in the Alarm',
        type=str,
    )
    parser.add_argument(
        '-d',
        '-demo',
        required=False,
        help='\n'.join(
            [
                'Run in demo mode. You can cancel by closing the window.',
                'Shutdown will only close the program after the timer.',
            ]
        ),
        action='store_true',
        default=False,
    )
    args = parser.parse_args()
    demo = args.d
    message = args.message

    timer = TimerWindow()
    root = App()
    root.mainloop()
