# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases' ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob' ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # Source components color definitions
  local current_dir="${${(%):-%x}:h}"
  if [[ -f "${current_dir}/colors.zsh" ]]; then
    source "${current_dir}/colors.zsh"
  fi

  # https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#batteries-included
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir
    vcs
    newline
    prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    command_execution_time
    background_jobs
    virtualenv
    context
    kubecontext
    aws
  )

  typeset -g POWERLEVEL9K_MODE="nerdfont-complete"

  # Basic style options
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=" "
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Prompt colors
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS}_FOREGROUND=${fg_prompt}
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS}_FOREGROUND=${fg_prompt_error}
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='󰅂'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='󰅁'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='󰅀'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=${fg_dir}

  # Python virtual environment
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=${fg_venv}
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

  # Context format
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="%F{$fg_ctx_root}%n%f%F{$fg_ctx}@%m%f"
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="%F{$fg_ctx}%n@%m%f"
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=

  # Previous command execution time
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=${fg_exec_time}

  # VCS (Git)
  typeset -g POWERLEVEL9K_VCS_FOREGROUND=${fg_vcs}
  typeset -g POWERLEVEL9K_VCS_LOADING_TEXT=
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0
  typeset -g POWERLEVEL9K_VCS_{INCOMING,OUTGOING}_CHANGESFORMAT_FOREGROUND=${fg_vcs_alt}
  typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
  typeset -g POWERLEVEL9K_VCS_DIRTY_ICON='*'
  typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=':⇣'
  typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=':⇡'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED}_ICON=
  typeset -g POWERLEVEL9K_VCS_{COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=1
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${${${P9K_CONTENT/⇣* :⇡/⇣⇡}// }//:/ }'

  # Time
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=${fg_time}
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # Kubernetes
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|skaffold|kubent|kubecolor|cmctl|sparkctl'
  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
    '*pr(o|d)*' PROD
    '*cat*' CAT
    '*st(a|g)*' STAGE
    '*dev*' DEV
    '*' DEFAULT)
  typeset -g POWERLEVEL9K_KUBECONTEXT_PROD_FOREGROUND=${fg_kube_prod}
  typeset -g POWERLEVEL9K_KUBECONTEXT_CAT_FOREGROUND=${fg_kube_cat}
  typeset -g POWERLEVEL9K_KUBECONTEXT_STAGE_FOREGROUND=${fg_kube_stage}
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEV_FOREGROUND=${fg_kube_dev}
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=${fg_kube_default}
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

  # AWS
  typeset -g POWERLEVEL9K_AWS_CLASSES=('*' DEFAULT)
  typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=${fg_aws}
  typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}${P9K_AWS_REGION:+ ${P9K_AWS_REGION//\%/%%}}'
  typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND=${fg_aws_eb}

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false

  ((!$+functions[p10k])) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

((${#p10k_config_opts})) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
