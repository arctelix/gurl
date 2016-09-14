# G for GURL - A git wrapper with url shortcuts

Use 'g' for 'gurl' as a general replacement for git except that wherever git 
expects a url you can use the gurl endpoint syntax: \<server\> [\<user\>/]\<repo\>

### Are you sick of typing out full urls for your git repos?

    > git clone https://github.com/user/repo_name
    > git remote add heroku https://git.heroku.com/repo_name
    
### Wouldn't it be great if you could do this instead?

    > gc gh repo_name
    > gra hr repo_name

## usage: 

gurl [help] [endpoints] [-uq] [<git commands>] \<server\> [\<user\>/]\<repo\>

NOTE: Omit '\<user\>/' for .gitignore user.name


## options: 

Must immediately follow gurl or g command

**help** : 
With no args following displays gurl and git help 
Otherwise use exactly how you would use git help

**endpoints** : 
Diplay a list of available endpoints

**-q** : 
Quiet mode, disables gurl messages
    
**-u <server\> [\<user\>/]\<repo\>** : 
Output url from endpoint

    # Download gurl from github with curl
    curl -LO "$(gurl -u gh gurl)/archive/master.zip"
    

## Endpoints

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

gurl cl  = gurl clone
gurl re  = gurl remote
gurl ra  = gurl remote add
gurl rs  = gurl remote show
gurl rr  = gurl remote remove
gurl rsu = gurl remote set-url
gurl rgu = gurl remote get-url

gurl is totally cool with .gitconfig aliases

    > git config alias.c clone
    > gurl c gh <repo>


## Aliases with G for Gurl installed:

Add add the following line to your shell's rc
file to enable g aliases: 'source gurl -q'

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


