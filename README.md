# G for GURL - A git wrapper with url shortcuts and more

Use 'g' for 'gurl' as a general replacement for git.  All git commands will work
exactly as they should with the added benefits of gurl. 

Gurl allows us to use endpoint shortcuts wherever git expects a url as well as
some additional git aliases.  Add g for gurl shortcuts to your shell's rc file
for total git bliss and save hundreds of keystrokes per day.

### Are you sick of typing out full urls for your git repos?

    > git clone https://github.com/user/repo_name
    > git remote add heroku https://git.heroku.com/repo_name
    
### Now the same commands exicuted with gurl..

    > gc gh repo_name
    > gra hr repo_name

## usage: 

gurl [help] [endpoints] [-uq] [\<git commands\>] \<server\> [\<user\>/]\<repo\>

NOTE: Omit '\<user\>/' for .gitignore user.name

## options: 

Must immediately follow gurl or g command

**help** : 
Display help for gurl and git.
Works the same as git help.

**list** : 
List available endpoints

**-t** : 
Test mode, output git command without execution

**-q** : 
Quiet mode, disables gurl messages
    
**-u <server\> [\<user\>/]\<repo\>** : 
Url mode, output converted url

    # Download gurl from github with curl
    curl -LO "$(gurl -u gh actelix/gurl)/archive/master.tar.gz"
    

## Endpoint Syntax

An endpoint is made up of \<server\> [\<user\>/]\<repo\>

### Builtins endpoint servers

github \| gh 
bitbucket \| bb 
heroku \| hr   

### Extending endpoint servers

Extend the built servers by adding a GURL_ENDPOINTS array
to your shell's rc file.  Each endpoint takes the
the form 'regex=url'.  

    GURL_ENDPOINTS=(
        mg|mygit=https://mygit.com/<user>/<repo>
    )
    
All occurrences of \<user\> & \<repo\> in the url will be replaced
during command execution.


## Aliases built into gurl:


re    = remote
ra    = remote add
rs    = remote show
rr    = remote remove
rao   = remote add origin
rsu   = remote set-url
rgu   = remote get-url
cl    = clone
cp    = cherry-pick
co    = checkout
ci    = commit
cm    = commit -am
st    = status
br    = branch
us    = reset HEAD --
dc    = diff --cached
lg    = log --graph #plus formatting
last  = log -1 --stat

gurl is totally cool with .gitconfig aliases

    > git config alias.c clone
    > gurl c gh <repo>


## Optional install G for Gurl:

Add add the following line to your shell's rc file 
to enable g for gurl aliases: 

    'source gurl -q'

## Aliases with G for Gurl installed:

g     = gurl
gc    = gurl clone
gra   = gurl remote add
grs   = gurl remote show
grr   = gurl remote remove
grao  = gurl remote add origin
grah  = gurl remote add heroku hr
gu    = gurl -qu


## EXAMPLE USAGE: 

The following examples are equivalent if <user> = config user.name:

Git clone

    > git clone https://github.com/<user>/<repo>
    > gurl clone gh <user>/<repo>

Git clone with g

    > g cl gh <repo>
    > gc gh <repo>

Git remote add

    > git remote add origin https://github.com/<user>/<repo>
    > gurl re add origin <user>/<repo>
    > gurl ra origin <repo>
    
Git remote add with g

    > g ra origin <repo>
    > gra origin <repo>
    > grao <repo>

### Coming soon:
    
More great git shortcuts will be added soon
    