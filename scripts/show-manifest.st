| log |
log := [:msg | | str |
    str := DateAndTime now printString, ': ', msg.
    FileStream stdout nextPutAll: str; nextPut: Character lf; flush.
    Transcript cr; show: str].

manifest := (MCWorkingCopy allManagers asSortedCollection:
        [ :a :b | a package name <= b package name ]) collect:
            [:ea | ea description].

log value: '===== Package manifest ====='.
manifest do: [:s | log value: s].
log value: '============================'.