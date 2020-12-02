# Set colorscheme based on iTerm's colorscheme

# def -docstring 'Set colorscheme (Light or Dark)' -override -params 1 \
# set-colorscheme %{
#     eval %sh{
#         if [ $1 = "Light" ]; then
#             echo colorscheme reeder
#         else
#             echo colorscheme gruvbox
#         fi
#     }
# }


# def -docstring 'Autodetect desired colorscheme' -override -params 0 \
# autodetect-colorscheme %sh{
#     # Set the background based on the current iterm2 profile
#     # Outputs the current iTerm background
#     bg="$(timeout 0.5 osascript <<END
# tell application "iTerm"
#     tell current window
#         tell current session
#             profile name 
#         end tell
#     end tell
# end tell
# END)"
# 
#     echo set-colorscheme "${bg:-Dark}"
# }
# 
# 
# autodetect-colorscheme

colorscheme gruvbox
