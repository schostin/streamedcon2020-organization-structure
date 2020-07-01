# Organization structure

This repository holds the source code for the initial setup of the organization and all folders.
Currently only the online-banking team gets created. Future teams could be setup in a similar way.
Next steps would then be to modularize the code to have a better reuse for it.
The storage bucket gets created in the seed project. The remote state will therefore be in the dedicated
bucket of the seed project. Also, only one repository gets created for the whole online-banking team.
I decided to do it like that since it was simply easier. You could of course create seperate repositories for 
each folder and just promote versionized modules across the different stages. Everything has up- and downsides 
in the end.
