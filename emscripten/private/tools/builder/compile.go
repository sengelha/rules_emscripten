package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

func compile(args []string) error {
	if (os.Getenv("PATH") == "") {
		return fmt.Errorf("No PATH environment variable set")
	}

	flags := flag.NewFlagSet("EmccCompile", flag.ExitOnError)
	emcc := flags.String("e", "", "The emcc executable")
	node := flags.String("n", "", "The node executable")
	output := flags.String("o", "", "The output object file")
	emConfig := flags.String("c", "", "The emscripten config file")
	configuration := flags.String("C", "", "The build configuration (opt, dbg, or fastbuild)")
	if err := flags.Parse(args); err != nil {
		return err
	}
	srcFiles := flags.Args()

	if (*emcc == "") {
		return fmt.Errorf("emcc binary not specified")
	}
	if (*node == "") {
		return fmt.Errorf("node binary not specified")
	}
	if (*output == "") {
		return fmt.Errorf("output file not specified")
	}
	if (*emConfig == "") {
		return fmt.Errorf("em_config file not specified")
	}
	if len(srcFiles) == 0 {
		return fmt.Errorf("source files not specified")
	}

	emccAbsPath, err := filepath.Abs(*emcc)
	if err != nil {
		return err
	}
	emConfigAbsPath, err := filepath.Abs(*emConfig)
	if err != nil {
		return err
	}
	nodeAbsPath, err := filepath.Abs(*node)
	if err != nil {
		return err
	}

	environ := os.Environ()
	environ = append(environ, fmt.Sprintf("EM_CONFIG=%s", emConfigAbsPath))
	environ = append(environ, fmt.Sprintf("EM_NODE_JS=%s", nodeAbsPath))

	emccArgs := []string{"-c", "-o", *output}
	if *configuration == "opt" {
		emccArgs = append(emccArgs, "-O3", "-DNDEBUG")
	} else {
		emccArgs = append(emccArgs, "-O0")
	}
	emccArgs = append(emccArgs, srcFiles...)

	cmd := exec.Command(emccAbsPath, emccArgs...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Env = environ
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("error starting compiler: %v", err)
	}

	return nil
}