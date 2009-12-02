NAME gcc, g++ - GNU project C and C++ Compiler (v2.7) SYNOPSIS gcc [ option |
filename ]... g++ [ option | filename ]... WARNING The information in this man
page is an extract from the full documentation of the GNU C compiler, and is
limited to the meaning of the options. This man page is not kept up to date
except when volunteers want to maintain it. If you find a discrepancy between
the man page and the software, please check the Info file, which is the
authoritative documentation. If we
--------------------------------------------------------------------------------
find that the things in this man page that are out of date cause significant
confusion or complaints, we will stop distributing the man page. The
alternative, updating the man page when we update the Info file, is impossible
because the rest of the work of maintaining GNU CC leaves us no time for that.
The GNU project regards man pages as obsolete and should not let them take time
away from other things.
For complete and current documentation, refer to the Info file `gcc' or the
manual Using and Porting GNU CC (for version 2.0). Both are made from the
Texinfo source file

Hallo, dies ist eine ziemlich lange Zeile, die in Html aber nicht umgebrochen
wird.
Zwei

produzieren zwei Newlines. Es gibt auch noch das tag
--------------------------------------------------------------------------------
wass einen Trenner darstellt. Achtung mehrere Leerzeichen irritieren Html
genauso wenig wie mehrere Leerzeilen. If you want only some of the four stages
(preprocess, compile, assemble, link), you can use `-x' (or filename suffixes)
to tell gcc where to start, and one of the options `-c', `-S', or `-E' to say
where gcc is to stop. Note that some combinations (for example, `-x cpp-output
-E') instruct gcc to do nothing at all.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
Since only one output file can be specified, it does not make sense to use `-o'
when compiling more than one input file, unless you are producing an executable
file as output.
