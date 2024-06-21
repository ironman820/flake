{
  cell,
  config,
  inputs,
}: let
  v = config.vars;
in {
  users.users.${v.username}.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHz3haZvvUzG6pSBmQmWxuDOF4pNfjzMd/lLFYjeE/b2AAAABHNzaDo= ironman"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILywKYzIIeui5T0jGyEhzHldnjJOFQ2/jVT1vP9sf30bAAAABHNzaDo= niceastman"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGJIIWSRNxMdMmVlgUvbXmBayjYzrjpt734phC8bCyCjAAAABHNzaDo= niceastman"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7 niceastman"
  ];
}
