Typewriter() {
    local text=""
    local delay=""
    local color_code=""
    local use_shell=false
    local no_newline=false
    local extra_newline=false

    # Global Color Standards
    local White="\033[1;37m"
    local Red="\033[1;31m"
    local Blue="\033[38;2;0;180;255m"
    local Green="\033[38;2;50;205;50m"
    local Yellow="\033[38;2;245;185;63m"
    local Orange="\033[1;38;2;244;117;27m"
    local Reset="\033[0m"

    local current_dir=$(pwd | sed "s|^$HOME|~|")

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -h|--help)
                echo -e "${Blue}NHZ Typewriter Engine - Help Menu${Reset}"
                echo -e "${White}Usage:${Reset} Typewriter [flags] \"text\" [speed]"
                echo -e "  -s         Show Shell Prompt AND Execute the command"
                echo -e "  -n         No newline at the end"
                echo -e "  -cn        Create an extra blank line at the end"
                echo -e "  -cw, -cr, -cb, -cg, -cy, -co (Color flags)"
                return 0
                ;;
            -cw) color_code="$White" ;;
            -cr) color_code="$Red" ;;
            -cb) color_code="$Blue" ;;
            -cg) color_code="$Green" ;;
            -cy) color_code="$Yellow" ;;
            -co) color_code="$Orange" ;;
            -s)  use_shell=true ;;  # Ito na ang magti-trigger ng execution!
            -n)  no_newline=true ;;
            -cn) extra_newline=true ;;
            -*)
                echo -e "${Red}Error: Unknown option '$1'${Reset}"
                Typewriter --help
                return 1
                ;;
            *)
                if [[ -z "$text" ]]; then text="$1";
                elif [[ -z "$delay" ]]; then delay="$1"; fi
                ;;
        esac
        shift
    done

    delay="${delay:-0.05}"

    # Save original text for execution
    local original_text="$text"

    # 1. Shell Prompt
    if [[ "$use_shell" == true ]]; then
        echo -e "${Blue}┌──(${Green}nhztech@termux${Blue})${Green}-${Blue}[${Reset}${current_dir}${Blue}]${Reset}"
        echo -ne "${Blue}└─\>${Reset} $ "

        sleep 0.5 # Delay bago mag-type
    fi

    [[ -n "$color_code" ]] && echo -ne "$color_code"

    # 2. Typewriter Loop
    while [[ -n "$text" ]]; do
        if [[ "$text" =~ ^($'\e'\[[0-9;]*[mK]) ]]; then
            echo -ne "${BASH_REMATCH[1]}"
            text="${text#${BASH_REMATCH[1]}}"
        else
            char="${text:0:1}"
            echo -n "$char"
            sleep "$delay"
            text="${text:1}"
        fi
    done

    # 3. Newlines
    [[ -n "$color_code" ]] && echo -ne "$Reset"
    [[ "$no_newline" == false ]] && echo ""

    # 4. AUTO-EXECUTE LOGIC (Triggered by -s)
    if [[ "$use_shell" == true ]]; then
        sleep 0.5 # Wait a bit na parang pinindot ang enter
        eval "$original_text"
    fi

    [[ "$extra_newline" == true ]] && echo ""
}
