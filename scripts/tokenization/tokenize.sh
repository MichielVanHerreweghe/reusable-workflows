#!/bin/bash

# Define default configurations
TOKEN_PREFIX="${TOKEN_PREFIX:-<<}"      # Default prefix '{{'
TOKEN_SUFFIX="${TOKEN_SUFFIX:->>}"      # Default suffix '}}'
LOG_FILE="${LOG_FILE:-token_replacer.log}"

# Function to log messages
log() {
    local level="$1"
    local message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $level: $message"
}

# Function to handle errors
error_exit() {
    local message="$1"
    log "ERROR" "$message"
    exit 1
}

# Function to replace tokens in a file
replace_tokens_in_file() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        error_exit "File not found: $file"
    fi

    while IFS= read -r line; do
        if [[ $line == *"$TOKEN_PREFIX"*"$TOKEN_SUFFIX"* ]]; then
            for env_var in $(env | awk -F= '{print $1}'); do
                local token="$TOKEN_PREFIX$env_var$TOKEN_SUFFIX"
                if [[ "$line" == *"$token"* ]]; then
                    local value="${!env_var}"
                    if [[ -z "$value" ]]; then
                        log "WARNING" "Environment variable '$env_var' is not set, leaving token '$token' unchanged."
                    else
                        line="${line//$token/$value}"
                        # log "INFO" "Replaced token '$token' with value '$value' in file '$file'."
                    fi
                fi
            done
        fi
        echo "$line"
    done < "$file" > "$file.tmp" && mv "$file.tmp" "$file" || error_exit "Failed to process file: $file"
}

# Function to replace tokens in multiple files
replace_tokens_in_files() {
    local files=("$@")

    if [[ ${#files[@]} -eq 0 ]]; then
        error_exit "No files specified for token replacement."
    fi

    for file in "${files[@]}"; do
        replace_tokens_in_file "$file"
    done
}

# Main script execution
main() {
    if [[ $# -eq 0 ]]; then
        error_exit "Usage: $0 <file1> <file2> ... [--prefix=PREFIX] [--suffix=SUFFIX] [--log=LOG_FILE]"
    fi

    # Parse command line arguments
    for arg in "$@"; do
        case $arg in
            --prefix=*)
                TOKEN_PREFIX="${arg#*=}"
                ;;
            --suffix=*)
                TOKEN_SUFFIX="${arg#*=}"
                ;;
            --log=*)
                LOG_FILE="${arg#*=}"
                ;;
            *)
                FILES+=("$arg")
                ;;
        esac
    done

    replace_tokens_in_files "${FILES[@]}"
    log "INFO" "Token replacement completed successfully."
}

# Execute the main function
main "$@"