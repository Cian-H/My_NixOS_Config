package main

import (
    "bufio"
    "flag"
    "fmt"
    "os"
    "path/filepath"
    "strings"
)

const valueToChange = "kb_layout"

func readLayouts(layoutFile string) ([]string, error) {
    file, err := os.Open(layoutFile)
    if err != nil {
        return nil, err
    }
    defer file.Close()

    var layouts []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        layout := strings.TrimSpace(scanner.Text())
        if layout != "" {
            layouts = append(layouts, layout)
        }
    }

    if err := scanner.Err(); err != nil {
        return nil, err
    }

    // To prevent index out of range error in toggleLine function
    layouts = append(layouts, layouts[0]) // Cycle back to the first layout

    return layouts, nil
}

func isTargetLine(line string) bool {
    return strings.Contains(line, valueToChange)
}

func readCurrentConfig(configFile string) ([]string, error) {
    file, err := os.Open(configFile)
    if err != nil {
        return nil, err
    }
    defer file.Close()

    var lines []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }

    if err := scanner.Err(); err != nil {
        return nil, err
    }

    return lines, nil
}

func writeNewConfig(lines []string, configFile string) error {
    file, err := os.Create(configFile)
    if err != nil {
        return err
    }
    defer file.Close()

    for _, line := range lines {
        _, err := file.WriteString(line + "\n")
        if err != nil {
            return err
        }
    }
    return nil
}

func toggleLine(line string, layouts []string) string {
    var builder strings.Builder

    indentLength := len(line) - len(strings.TrimLeft(line, " \t"))
    builder.Grow(len(line)) // Preallocate enough space to avoid multiple allocations

    builder.WriteString(strings.Repeat(" ", indentLength))

    codeAndComments := strings.SplitN(line, "#", 2)
    code := strings.TrimSpace(codeAndComments[0])
    tokens := strings.Fields(code)
    currentLayout := tokens[len(tokens)-1]
    index := (strings.Index(strings.Join(layouts, " "), currentLayout)/len(currentLayout) + 1) % len(layouts)
    tokens[len(tokens)-1] = layouts[index]
    builder.WriteString(strings.Join(tokens, " "))

    if len(codeAndComments) > 1 {
        builder.WriteString(" # ")
        builder.WriteString(codeAndComments[1])
    }

    return builder.String()
}

func cycleKbLayout(configFile, layoutFile string) error {
    layouts, err := readLayouts(layoutFile)
    if err != nil {
        return err
    }

    lines, err := readCurrentConfig(configFile)
    if err != nil {
        return err
    }

    var newLines []string
    for _, line := range lines {
        if isTargetLine(line) {
            line = toggleLine(line, layouts)
        }
        newLines = append(newLines, line)
    }

    return writeNewConfig(newLines, configFile)
}

// Define flags for the input files
var configFile = flag.String("c", "inputs.conf", "Path to the configuration file")
var layoutFile = flag.String("l", "kb_layouts.txt", "Path to the keyboard layout file")

func main() {
    // Parse command-line flags
    flag.Parse()

    // Determine the absolute paths based on provided flags
    hyprDir, err := filepath.Abs(filepath.Dir(os.Args[0]))
    if err != nil {
        fmt.Println("Error getting directory: %v", err)
    }

    configFilePath := filepath.Join(hyprDir, *configFile)
    layoutFilePath := filepath.Join(hyprDir, *layoutFile)

    // Call the cycleKbLayout function with the paths from the flags
    if err := cycleKbLayout(configFilePath, layoutFilePath); err != nil {
        fmt.Println("Error cycling keyboard layout: %v", err)
    }
}

