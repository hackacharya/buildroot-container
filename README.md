
https://github.com/hackacharya/buildroot-container

##Intro
A simple set of scripts to create a container image 
for any version of buildroot with some minor 
inconveniences removed. 

##Todo
\_pkg\_OVERRIDE\_SRCDIR


##Howto - Use dockerhub images
```
   docker pull hackacharya/buildroot:latest
   docker run --rm -it hackacharya/buildroot:latest
   docker run --rm -it hackacharya/buildroot:2018.08
```

##Howto - Build and run locally
```
  git clone git@github.com:hackacharya/buildroot-container.git
  cd buildroot-container
  ./build.sh
  ./run.sh
```

##Thanks
To the folks at docker and buildroot.org.


--
hackacharya
