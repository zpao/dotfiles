#! /bin/bash

# Sets up links to files needed from a proper Mercurial sub-repository for development.
# First clone a Mercurial repository to ./hg-repo.
# Then do `make local` there.

cp -f hg-repo/hg .
ln -fs hg-repo/mercurial .
( cd hgext; ln -fs ../hg-repo/hgext/{__init__,graphlog,patchbomb,color,mq}.py . )

