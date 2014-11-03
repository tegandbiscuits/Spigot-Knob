#!/bin/bash
# v1.0.2

if [ -f knob.conf ]; then
  source knob.conf
else
  echo "Missing config file, so it was created"
  echo "Run config to fill the settings"
  touch knob.conf
fi

showHelp() {
  printf "\n\tSpigot-Knob (v1.0.1) is a small bundle of commands to help run Spigot MC servers\n\n"
  printf "\tstart           Start the server in it's own screen\n"
  printf "\tstop            Stop the server gracefully (and stop the screen)\n"
  printf "\tkill            Kill the server & screen (unpreferred over stop)\n"
  printf "\trestart         Reload the server\n"
  printf "\treload-plugins  Reloads the plugins and configuration\n"
  printf "\tsay             Say a message as the server\n"
  printf "\tsave            Saves your worlds\n"
  printf "\tbackup          Backup your world\n"
  printf "\tbackup-server   Backs up the whole server folder\n"
  printf "\tconfig          Runs the configure utility\n"
  printf "\tscreen          Change to the screen the server is on (will stop screen if quit)\n"
  printf "\thelp / ?        Show this help screen\n"
}


startServer() {
  printf "\tStarting server (in detached screen). May take a bit\n"
  cd $SPIGOTDIR
  screen -S "spigot-server" -d -m bash -c "java $SPIGOTFLAGS -jar $SPIGOTNAME"
  # There should be a message what the screen id is
  # It'd also be cool to say when it's finished starting
}


stopServer() {
  printf "\tStopping server. May take a few seconds.\n"
  serverSay "$SHUTDOWNMSG"
  sleep $SHUTDOWNWAIT
  screen -S "spigot-server" -p 0 -X stuff "stop$(printf \\r)"
}


killServer() {
  printf "\tKilling server (by killing screen)\n"
  screen -S "spigot-server" -X quit
  # Need to make sure this doesn't just create an orphan process
}


restartServer() {
  # Restart command stops server and kills screen
  # Using stop then start functions since it's same result
  stopServer
  startServer
}


reloadPlugins() {
  printf "\tReloading plugins\n"
  screen -S "spigot-server" -p 0 -X stuff "reload plugins$(printf \\r)"
}


serverSay() {
  printf "\tSaying: $1\n"
  screen -S "spigot-server" -p 0 -X stuff "say $1$(printf \\r)"
}


saveServer() {
  printf "\tSaving server\n"
  screen -S "spigot-server" -p 0 -X stuff "save-all$(printf \\r)"
}


backupWorld() {
  if [ -d $BACKUPDIR ]; then
    printf "\tBacking up world, $WORLDNAME, to $BACKUPDIR\n"
    cd $SPIGOTDIR
    tar -czf "$BACKUPDIR/$WORLDNAME-$(date +'%H-%M-%d-%m-%Y').tar.gz" $WORLDNAME $(printf $WORLDNAME)_nether $(printf $WORLDNAME)_the_end
  else
    printf "\tCreating $BACKUPDIR path\n"
    mkdir -p $BACKUPDIR
    backupWorld
  fi
}


backupServer() {
  if [ -d $BACKUPDIR ]; then
    printf "\tBacking up whole server, to $BACKUPDIR\n"
    cd $SPIGOTDIR
    tar -czf "$BACKUPDIR/server-backup-$(date +'%H-%M-%d-%m-%Y').tar.gz" .
  else
    printf "\tCreating $BACKUPDIR path\n"
    mkdir -p $BACKUPDIR
    backupServer
  fi
}


showScreen() {
  screen -r "spigot-server"
}


configScript() {
  spigotPath() { 
    printf "Please enter the absolute path for the folder Spigot is running in\n"
    read
    if [ "$REPLY" == "" ]; then
      spigotPath
    else
      SPIGOTDIR=$REPLY
    fi
  }
  
  spigotName() {
    printf "Please enter the name of your Spigot jar file (spigot.jar)\n"
    read
    if [ "$REPLY" == "" ]; then
      echo "spigot.jar"
      SPIGOTNAME="spigot.jar"
    else
      SPIGOTNAME=$REPLY
    fi
  }

  spigotFlags() {
    printf "Please enter any flags you want when starting your server (-Xms512m -Xmx1024m)\n"
    read
    if [ "$REPLY" == "" ]; then
      echo "-Xms512m -Xmx1024m"
      SPIGOTFLAGS="-Xms512m -Xmx1024m"
    else
      SPIGOTFLAGS=$REPLY
    fi
  }

  spigotWorld() {
    printf "Please enter the name of your world (world)\n"
    read
    if [ "$REPLY" == "" ]; then
      echo "world"
      WORLDNAME="world"
    else
      WORLDNAME=$REPLY
    fi
  }

  backupPath() {
    printf "Please enter the absolute path where you want backups to go\n"
    read
    if [ "$REPLY" == "" ]; then
      backupPath
    else
      BACKUPDIR=$REPLY
    fi
  }

  shutdownTime() {
    printf "Seconds until shutdown and restart (5)"
    read
    if [ "$REPLY" == "" ]; then
      echo "5"
      SHUTDOWNWAIT=5
    else
      SHUTDOWNWAIT=$REPLY
    fi
  }

  shutdownMsg() {
    printf "Message before shutting down and restarting (Shutting down)"
    read
    if [ "$REPLY" == "" ]; then
      echo "Shutting down"
      SHUTDOWNMSG="Shutting down"
    else
      SHUTDOWNMSG=$REPLY
    fi
  }

  runConfig() {
    spigotPath
    spigotName
    spigotFlags
    spigotWorld
    backupPath
    shutdownTime
    
    checkConfig() {
      echo "Spigot Path: $SPIGOTDIR"
      echo "Spigot File Name: $SPIGOTNAME"
      echo "Start Flags: $SPIGOTFLAGS"
      echo "World Name: $WORLDNAME"
      echo "Backup Directory: $BACKUPDIR"
      echo "Shutdown pause: $SHUTDOWNWAIT"
      echo "Shutdown message: $SHUTDOWNMSG"
      printf "Does this look good? (y/n)\n"
      read
      case $REPLY in
        "y") echo "Saving config";;
        "Y") echo "Saving config";;
        "n") runConfig ;;
        "N") runConfig ;;
        *)
          printf "Please enter y or n\n"
          checkConfig ;;
      esac
    }
    checkConfig

    printf "SPIGOTDIR=\"$SPIGOTDIR\"\n" > knob.conf
    printf "SPIGOTNAME=\"$SPIGOTNAME\"\n" >> knob.conf
    printf "SPIGOTFLAGS=\"$SPIGOTFLAGS\"\n" >> knob.conf
    printf "WORLDNAME=\"$WORLDNAME\"\n" >> knob.conf
    printf "BACKUPDIR=\"$BACKUPDIR\"\n" >> knob.conf
    printf "BACKUPDIR=\"$SHUTDOWNWAIT\"\n" >> knob.conf
    printf "SHUTDOWNMSG=\"$SHUTDOWNWAIT\"\n" >> knob.conf
  }

  if [ -f knob.conf ]; then
    printf "\n[WARNING]: file name 'knob.conf' already exists in this directory, do you want to overwrite it? (y/n): "
    read
    case $REPLY in
      "y")
        printf "Will overwrite\n\n"
        runConfig ;;
      "Y")
        printf "Will overwrite\n\n"
        runConfig ;;
      "n")
        printf "Stopping\n\n"
        cancel ;;
      "N")
        printf "Stopping\n\n"
        cancel ;;
      *)
        printf "\n\tPlease enter y or n\n"
        configScript ;;
    esac
  fi
}

case $1 in
  "start")
    startServer ;;
  "stop")
    stopServer ;;
  "kill")
    killServer ;;
  "restart")
    restartServer ;;
  "reload-plugins")
    reloadPlugins ;;
  "say")
    serverSay "$2" ;;
  "save")
    saveServer ;;
  "backup")
    backupWorld ;;
  "backup-server")
    backupServer ;;
  "version")
    echo "will show version eventually" ;;
  "screen")
    showScreen ;;
  "config")
    configScript ;;
  "help")
    showHelp ;;
  "?")
    showHelp ;;
  *)
    showHelp ;;
esac

