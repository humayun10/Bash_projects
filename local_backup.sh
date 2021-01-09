#!/bin/bash 

rsync -av /home/halam/* /backup #> /dev/null
rsync -av /home/halam/.[^.]* /backup #> /dev/null #Copies hidden files too

COUNT_HOME=$(find /home/halam -type f | wc -l)
COUNT_DEST=$(find /backup -type f | wc -l)

echo ""
echo "File count for  home is: $COUNT_HOME"
echo "File count for destination: $COUNT_DEST"
echo ""

## Counting the files on both directories
if [ $COUNT_HOME -eq $COUNT_DEST ]
then
    echo -e "\e[32mEverything has been copied and looks good. Will now compare both directories\e[0m"
else
    x=1
    echo -e "\e[31mSomething is not right\e[0m\n"
    echo "Examine files here:"
fi

## If file count of both directories do not match then check the differences in filenames
if [ x=1 ]
  then
  diff -rq /home/halam/ /backup/ 2> /dev/null | grep "Only"
fi

HOME_SIZE=$(du -sh --apparent-size /home/halam/ | awk '{print $1}')
TARGET_SIZE=$(du -sh --apparent-size /backup | awk '{print $1}')

echo -e "\nHome directory size = $HOME_SIZE\tBackup directory size = $TARGET_SIZE\n"

## Comparing directory size and file count
if [ $HOME_SIZE = $TARGET_SIZE ]&& [ $COUNT_HOME -eq $COUNT_DEST ]
then 
    echo "Both directories are equal in size and backup SUCCESSFUL"
else 
    echo "Backup has failed!"
fi
