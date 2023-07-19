set direction $argv[1]
set current_workspace (i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
set workspaces     

set current_workspace_index (contains -i "$current_workspace" $workspaces)

set desired_index 
switch $direction
    case "left"
        set desired_index (math $current_workspace_index - 1)
    case "right"
        set desired_index (math $current_workspace_index + 1)
end

switch $desired_index
    case 0
        set desired_index (count $workspaces)
    case (math (count $workspaces) + 1)
        set desired_index 1
end


if test $argv[2]
    i3-msg move container to workspace $workspaces[$desired_index]
end

i3-msg workspace $workspaces[$desired_index]