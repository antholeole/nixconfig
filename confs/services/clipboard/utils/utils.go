package utils

import (
	"fmt"
	"os/exec"
)

var Port = "9791"

func Copy(toCopy, wlcopy string) error {
	cmd := exec.Command("/bin/bash", "-c", fmt.Sprintf("echo \"%s\" | %s", toCopy, wlcopy))
	_, err := cmd.Output()
	return err
}
