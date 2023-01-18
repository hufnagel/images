setoption("acl NET_LOCAL src", "'$SQUID_IPRANGE'")
setoption("cache_mem", "'$SQUID_CACHE_MEM'")
setoptionparameter("cache_dir", 3, "'$SQUID_CACHE_DISK'")
setoptionparameter("cache_dir", 2, "'$SQUID_CACHE_DISK_LOCATION'")
insertline("^http_access deny CONNECT","acl TOFERMILAB dst fc00::/7fe80::/10 131.225.0.0/16")
insertline("^http_access deny CONNECT","acl CONNECTPORTS port 1094 1095 15000-35000")
insertline("^http_access deny CONNECT","http_access allow CONNECT TOFERMILAB CONNECTPORTS")
