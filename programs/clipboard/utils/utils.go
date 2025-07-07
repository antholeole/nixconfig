package utils

import (
	"fmt"
	"os/exec"
	"bytes"
)

var Port = "9791"

func Copy(toCopy, wlcopy string) error {
	cmdLine := fmt.Sprintf("echo \"$(base64 -d %s)\" | %s -n 2> /dev/null", toCopy, wlcopy)
	cmd := exec.Command("/bin/bash", "-c", cmdLine)

	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		// If the command failed, return a new error that includes the original error and stderr output.
		// Check if it's an ExitError to get the specific exit code.
		if exitErr, ok := err.(*exec.ExitError); ok {
			return fmt.Errorf("command (%s) failed with exit code %d: %w; stderr: %s", cmdLine, exitErr.ExitCode(), err, stderr.String())
		}
		// For other types of errors (e.g., command not found), just include the original error and stderr.
		return fmt.Errorf("command failed: %w; stderr: %s", err, stderr.String())
	}
	return nil
}
