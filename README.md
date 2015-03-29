
1. Install [rcm](https://github.com/thoughtbot/rcm#installation).
2. Get dotfiles: 

  ```bash
  cd
  git clone git@github.com:ripta/dotfiles.git .dotfiles
  cd .dotfiles
  git submodule init
  git submodule update
  ```

3. Preview dotfiles: `RCRC=~/.dotfiles/rcrc lsrc`
4. Install dotfiles: `RCRC=~/.dotfiles/rcrc rcup -v`

