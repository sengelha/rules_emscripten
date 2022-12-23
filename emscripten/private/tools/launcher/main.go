package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func fileExists(f string) bool {
	if _, err := os.Stat(f); err == nil {
		return true
	}
	return false
}

func findManifestFile() (string, error) {
	if manifestFile, ok := os.LookupEnv("RUNFILES_MANIFEST_FILE"); ok {
		return manifestFile, nil
	}
	if fileExists("MANIFEST") {
		return "MANIFEST", nil
	}
	return "", fmt.Errorf("Could not find MANIFEST file")
}

func parseManifest(manifestFile string) (map[string]string, error) {
	f, err := os.Open(manifestFile)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	results := map[string]string{}
	for scanner.Scan() {
		arr := strings.Fields(scanner.Text())
		if len(arr) == 2 {
			results[arr[0]] = arr[1]
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return results, nil
}

func resolveRunfile(ref string) (string, error) {
	// If we're passed in a path that we can open directly, use that
	resolvedPath := filepath.FromSlash(ref)
	if _, err := os.Stat(resolvedPath); err == nil {
		return resolvedPath, nil
	}

	// Otherwise, try to resolve it from a manifest file (if it exists)
	manifestFile, err := findManifestFile()
	if err != nil {
		return "", err
	}

	manifest, err := parseManifest(manifestFile)
	if err != nil {
		return "", err
	}

	if v, found := manifest[ref]; found {
		p := filepath.FromSlash(v)
		return p, nil
	}

	return "", fmt.Errorf("Runfile %s not found in manifest %s", ref, manifestFile)
}

func main() {
	log.SetPrefix("launcher: ")

	node := flag.String("n", "", "The node executable")
	entryPoint := flag.String("e", "", "The js entrypoint")
	flag.Parse()

	nodePath, err := resolveRunfile(*node)
	if err != nil {
		log.Fatal(err)
	}
	entryPointPath, err := resolveRunfile(*entryPoint)
	if err != nil {
		log.Fatal(err)
	}

	cmd := exec.Command(nodePath, entryPointPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}
}