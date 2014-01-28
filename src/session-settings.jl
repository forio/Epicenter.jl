
# -------

function refresh_timeout(cid, msgtype, data)
    # check to see if this was a call from the persistence thread,
    # we don't want to count those as activity
    proc = get(data, "proc", "")
    if proc != "" && (contains(proc, "fetch_records") || contains(proc, "take_records"))
        return
    end

    global TIME_LAST_MODIFIED = time()
end

function setup_idle_timeout(timeout, interval = 120)
    # check for other idle timers
    if isdefined(:IDLE_TIMER)
        stop_timer(IDLE_TIMER)
    end

    global IDLE_TIMEOUT = timeout
    global TIME_LAST_MODIFIED = time()
    global IDLE_TIMER = Timer( (t, status) -> begin
        if TIME_LAST_MODIFIED + IDLE_TIMEOUT < time()
            # probably we want to send a request to terminate
            # or time-out this session... unfortunately we
            # cannot do blocking calls. For now:

            # Requests.delete("http://localhost/sessions/$sid")
            exit()
        end
    end)
    start_timer(IDLE_TIMER, interval, interval)

    event_sys = Main.Juliet.get_system(Main.Juliet.Event)
    Main.Juliet.Event.register_handler(event_sys, "networkIn", refresh_timeout)

    nothing
end

# -------
