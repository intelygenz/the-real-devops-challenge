# PROPOSED SOLUTIONS TO THIS CHALLENGE

Hi IGZ Team, let me present the solutions for this challenge.

### **CHALLENGE 1**
_______


----
### **CHALLENGE 2**
_____

----
### **CHALLENGE 3 AND 4**
_____
I have written three different dockerfiles, one for the app with the application code, another for the mongo database and finally a mongo seed that it's used for seeding the mongo restaurant database. 

The main Dockerfile for the python application is in the root directory.
All configuration, including shell scripts, Dockerfiles for mongo database and mongo seed, and data to import is organized in a separate folder in order to have a good organization

----
### **CHALLENGE 5**
_____
The docker-compose file ( stack.yml ) builds the images and all containers are deployed in the same network. Enviroment variables are defined using different files
