# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·
# Configure Anaconda Python if installed.
#
# Author: oqkr@pm.me
# Source: https://github.com/oqkr/dotfiles
# · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · · ·

# If an Anaconda Python is installed, add its bin directory to the beginning
# of PATH to use it rather than the system Python. When multiple installations
# exist, prefer Anaconda to Miniconda and Python 3.x to Python 2.x.
for d in ~/{ana,mini}conda{3,,2}; do
  if [[ -d "${d}" && -x "${d}/bin/conda" && -x "${d}/bin/python" ]]; then
    dotfiles::pathmunge "${d}/bin"
    [[ -d "${d}/envs/py3" ]] && alias py3='source activate py3'
    [[ -d "${d}/envs/py2" ]] && alias py2='source activate py2'
    break
  fi
done
unset -v d
