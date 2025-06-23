{...}: {
  config = {
    users.motd = ''
          __  __      _       ____
        / / / /___  (_)___  / __/___  _________  ____ ___
       / / / /_  / / / __ \/ /_/ __ \/ ___/ __ \/ __ `__ \
      / /_/ / / /_/ / / / / __/ /_/ / /__/ /_/ / / / / / /
      \____/ /___/_/_/ /_/_/  \____/\___/\____/_/ /_/ /_/
      Welcome to Uzinfocom's Instances Infrastructure!

      All Uzinfocom's instances are managed via NixOS'es declarative configuration system.
      Any global changes has to be applied to the public configuration repository at:
      https://github.com/uzinfocom-org/instances

      # Server Instances & Applications
      Any server instances and applications must be hosted at /srv path. Each app
      should have its own directory with short and clear name. For example:
      /srv/uzinfocom-website, /srv/uzinfocom-telegram-bot
    '';
  };
}
