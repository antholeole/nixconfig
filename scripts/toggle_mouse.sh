MOUSE_ID=$1

MOUSE_ENABLED=xinput list-props $MOUSE_ID | grep "Device Enabled" | awk "{print $NF}"

echo $MOUSE_ENABLED
#DESIRED_STATE = 1 - $MOUSE_ENABLED

#input set-prop $MOUSE_ID $DESIRED_STATE
