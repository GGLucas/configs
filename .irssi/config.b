servers = (
    {
        address = "irc.oftc.net";
        chatnet = "OFTC";
        autoconnect = "Yes";
    },
    {
        address = "irc.freenode.net";
        chatnet = "Freenode";
        autoconnect = "Yes";
    }
);

chatnets = {
    Freenode = {
        type = "IRC;
        autosendcmd = "/msg NickServ IDENTIFY serpent";
    };
};

settings = {
    core = {
        real_name = "Lucas";
        user_name = "GGLucas";
        nick = "GGLucas";
    };
    "fe-common/core" = {
        show_names_on_join = "no";
    }
};
