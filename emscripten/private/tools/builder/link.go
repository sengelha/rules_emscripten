package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func link(args []string) error {
	flags := flag.NewFlagSet("EmccLink", flag.ExitOnError)
	emcc := flags.String("e", "", "The emcc executable")
	output := flags.String("o", "", "The output object file")
	emConfig := flags.String("c", "", "The emscripten config file")
	linkopts := flags.String("l", "", "Link options to pass to emcc")
	modularize := flags.Bool("m", false, "Whether to modularize the result")
	prejs := flags.String("p", "", "The file to use as a pre-js")
	postjs := flags.String("P", "", "The file to use as a post-js")
	extprejs := flags.String("x", "", "The file to use as an extern-pre-js")
	extpostjs := flags.String("X", "", "The file to use as an extern-post-js")
	wasm := flags.Bool("w", false, "Whether to output WASM")
	if err := flags.Parse(args); err != nil {
		return err
	}
	objFiles := flags.Args()

	if *emcc == "" {
		return fmt.Errorf("emcc binary not specified")
	}
	if *output == "" {
		return fmt.Errorf("output file not specified")
	}
	if *emConfig == "" {
		return fmt.Errorf("em_config file not specified")
	}
	if len(objFiles) == 0 {
		return fmt.Errorf("object files not specified")
	}

	emConfigAbsPath, err := filepath.Abs(*emConfig)
	if err != nil {
		return err
	}
	environ := os.Environ()
	environ = append(environ, fmt.Sprintf("EM_CONFIG=%s", emConfigAbsPath))
	if os.Getenv("PATH") == "" {
		environ = append(environ, "PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin")
	}

	emccArgs := []string{"-o", *output}
	if *modularize {
		emccArgs = append(emccArgs, "-s", "MODULARIZE=1")
	}
	if *linkopts != "" {
		emccArgs = append(emccArgs, strings.Split(*linkopts, ";")...)
	}
	if *prejs != "" {
		emccArgs = append(emccArgs, "--pre-js", *prejs)
	}
	if *postjs != "" {
		emccArgs = append(emccArgs, "--post-js", *postjs)
	}
	if *extprejs != "" {
		emccArgs = append(emccArgs, "--extern-pre-js", *extprejs)
	}
	if *extpostjs != "" {
		emccArgs = append(emccArgs, "--extern-post-js", *extpostjs)
	}
	if !*wasm {
		emccArgs = append(emccArgs, "-s", "WASM=0")
	}
	emccArgs = append(emccArgs, objFiles...)
	cmd := exec.Command(*emcc, emccArgs...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Env = environ
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("error starting compiler: %v", err)
	}

	return nil
}
