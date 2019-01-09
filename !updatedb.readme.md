GNU locate supports three different database format, those are old, slocate and LOCATE02 (default).
updatedb command uses `frcode` for creating slocate and LOCATE02 format databases, 
`tr`, `sed`, `bigram` and `code` commands for creating old format database.
`homemade.mk` contains targets to control the procedure above
and helps to create databases manually.

GNU locate command accepts `PRUNEPATHS`.
It is useful for creating databases in Cygwin or MobaXterm envorinment.
Without appropreate `PRUNEPATHS`, 
`updatedb` runs forever because of unexpected cyclic recursion.

```
git clone --depth 1 git@gist.github.com:20a4d99160f824080c710c59fcfb6b3d.git updatedb-playground
```