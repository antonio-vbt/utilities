# Using multiple SSH keys in the same machine

Github authentication via SSH keys relies on the key not only to decide whether a machine should be trusted or not, but also to decide which account a given request is related to. Each key can be tied to only a single Github account.

But there are instances where you may need to use the same machine to access different accounts. The steps to do so:

1. Create two different keys and associate each to a different account
    - If one of the keys uses the default name, e.g. `id_ed25519`, it will be the one used by default when no additional settings are specified, i.e. you can run the standard git workflow
    - When using a specific key is desired, follow the next step
2. When cloning a repo, use `-c "core.sshCommand=ssh -i <key-file>"` to define the ssh command to be used for that repo. E.g.

```
git clone -c "core.sshCommand=ssh -i ~/.ssh/my-key" git@github.com:my-repo
```

If the repo is already present, just apply the `core.sshCommand` config to it:

```
/my-repo $ git config core.sshCommand "ssh -i ~/.ssh/my-key"
```

- [Source](https://superuser.com/a/912281)
