# tmp kludge to reduce repeated obis queries.
#
# WARN: your data *WILL* be out of date if you use this.
# To update your data you must clear the cache:
#    `rm /tmp/robis_query_cache*`
#
# For a better caching method see:
#    https://github.com/iobis/robis/issues/53

library(glue)


sanitize_query_id = function(
    query
){
    # returns string is ok for usage in query_id
    # removes spaces and makes all lowercase
    return(tolower(gsub("\ ", "_", query)))
}

get_query_id_fpath = function(
    query_id_string
){
    # TODO: check query_id_string is ok:
    #    assert query_id_string == sanitize_query_id(query_id_string)
    cache_dir = "~/.cache/robis_query_cache"
    dir.create(file.path(cache_dir), showWarnings = FALSE)  # ensure dir exists
    return(file.path(cache_dir, glue("{query_id_string}.rds")))
}


has_cache = function(
    query_id_string
){
    # returns true if given query id is cached
    if (file.exists(get_query_id_fpath(query_id_string))){
        return(TRUE)
    } else {
        return(FALSE)
    }
}


load_cache = function(
    query_id_string
){
    return(read.csv(
        get_query_id_fpath(query_id_string)
    ))
}


save_cache = function(
    query_id_string, data
){
    write.csv( data, file = get_query_id_fpath(query_id_string) )
}
