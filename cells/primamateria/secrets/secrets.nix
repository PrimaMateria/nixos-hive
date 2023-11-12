let
  hive-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQ+l9Z5SIy1LcwuLAiBJBkDaz5io47z9LTeUnd/iVN2";
in
{
  "secrets.age".publicKeys = [ hive-key ];
}
