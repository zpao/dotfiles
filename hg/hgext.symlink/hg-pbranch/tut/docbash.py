#! /usr/bin/env python

from __future__ import with_statement
from subprocess import Popen, PIPE, STDOUT
import sys, re, cgi

def unformat(line):
    res = line.strip("\n")
    if res.startswith("\t"):
        res = res[1:]
    return res.strip(" $")

class Runner:

    def __init__(self):
        self.HGCALL = re.compile("(^|; )hg ")
        self.shell = Popen("/bin/bash", stdin=PIPE, stdout=PIPE, stderr=STDOUT)

    def run(self, cmdlines, script):

        def localhg(cmd):
            (res, _subs) = self.HGCALL.subn('$HGPATH/hg ', cmd)
            return res
        
        cmds = [l.strip("\n") for l in cmdlines]
        cmds = [localhg(l) for l in cmds]

        for l in cmds:
            script.write("%s\n" % l)

        cmd = "\n".join(cmds) + "\necho\necho ,,,,\n"
        self.shell.stdin.write(cmd)
        self.shell.stdin.flush()
        outlines = []
        stdout = self.shell.stdout
        l = None
        while True:
            l = stdout.readline()
            if l == ",,,,\n": break
            outlines.append(l.rstrip())
        while outlines and not outlines[-1]:
            del outlines[-1]
        return ["%s\n" % l for l in outlines]
    
    def close(self):
        self.shell.communicate("exit\n")

def run(srcname, tgtname, actname, scriptname):
    runner = Runner()
    with open(tgtname, "w") as tgt:
        code = 0
        input = 1
        have = [False, False]
        def startinput():
            if not have[code]:
                tgt.write('<notextile>\n<pre><code><span class="input">')
                have[code] = True
                have[input] = True
            elif not have[input]:
                tgt.write('</span><span class="input">')
                have[input] = True
        def startoutput():
            tgt.write('</span><span class="output">')
            have[input] = False
        def stoptranscript():
            if have[code]:
                tgt.write('</span></code></pre>\n</notextile>\n')
                have[:] = [False, False]
        with open(actname, "w") as act:
            with open(srcname) as src:
                with open(scriptname, "w") as script:
                    line = src.readline()
                    while line:
                        if line.startswith("\t$ "):
                            cmdlines = [line]
                            line = src.readline()
                            if cmdlines[0].endswith("eof\n"):
                                while line and not line.endswith("eof\n"):
                                    cmdlines.append(line)
                                    line = src.readline()
                                cmdlines.append(line)
                                line = src.readline()
                            wantlines = []
                            while line.startswith("\t") and not line.startswith("\t$ "):
                                wantlines.append(line)
                                line = src.readline()
                            scriptlines = [unformat(l) for l in cmdlines]
                            if scriptlines and scriptlines[0] == "EXIT":
                                print "EXITING"
                                return 
                            havelines = runner.run(scriptlines, script)

                            startinput()
                            for l in cmdlines:
                                act.write(l)
                                if l == "\n":
                                    tgt.write(l)
                                else:
                                    tgt.write(cgi.escape(l[1:]))

                            if havelines:
                                startoutput()
                                for l in havelines:
                                    if l == "\n":
                                        l = "_\n"
                                    act.write("\t")
                                    act.write(l)
                                    tgt.write(cgi.escape(l))
                        else:
                            stoptranscript()
                            tgt.write(line)
                            act.write(line)
                            line = src.readline()
                    stoptranscript()
    runner.close()


srcname = sys.argv[1]
tgtname = sys.argv[2]
actname= sys.argv[3]
scriptname = sys.argv[4]

print "Input: %s" % srcname
print "Target: %s" % tgtname
print "Actual: %s" % actname
print "Script: %s" % scriptname

run(srcname, tgtname, actname, scriptname)
