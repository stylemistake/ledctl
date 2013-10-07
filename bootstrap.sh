#!/bin/bash
cd `dirname $0`

mkdir -p deps temp rel

getdep() {
	url="$1"
	path="$2"
	if ! [ -e "${path}" ]; then
		git clone ${url} ${path}
		pushd ${path}
		make
		popd
		echo
	fi
}

getdep git://github.com/knutin/elli.git deps/elli
getdep git://github.com/tonyg/erlang-serial.git deps/serial

if ! [ -e "rebar" ]; then
	git clone git://github.com/rebar/rebar.git temp/rebar
	pushd temp/rebar
	./bootstrap
	popd
	cp temp/rebar/rebar rebar
	echo
fi

cat > launch.sh << EOF
#!/bin/bash
cd `dirname $0`
echo "ledctl: starting..."
env ERL_LIBS=deps erl -noshell -eval 'application:start(ledctl).' -pa deps/*/ebin ebin
EOF
chmod 755 launch.sh

pushd rel
rebar create-node nodeid=ledctl
cat > reltool.config << EOF
{sys, [
	{lib_dirs, []},
	{erts, [{mod_cond, derived}, {app_file, strip}]},
	{app_file, strip},
	{rel, "ledctl", "1", [ kernel, stdlib, sasl, ledctl ]},
	{rel, "start_clean", "", [ kernel, stdlib ]},
	{boot_rel, "ledctl"},
	{profile, embedded},
	{incl_cond, derived},
	{mod_cond, derived},
	{excl_archive_filters, [".*"]}, %% Do not archive built libs
	{excl_sys_filters, ["^bin/.*", "^erts.*/bin/(dialyzer|typer)",
	                   "^erts.*/(doc|info|include|lib|man|src)"]},
	{excl_app_filters, ["\.gitignore"]},
	{app, ledctl, [{mod_cond, app}, {incl_cond, include}, {lib_dir, ".."}]}
]}.
{target_dir, "ledctl"}.
{overlay, [
	{mkdir, "log/sasl"},
	{copy, "files/erl", "\{\{erts_vsn\}\}/bin/erl"},
	{copy, "files/nodetool", "\{\{erts_vsn\}\}/bin/nodetool"},
	{copy, "files/ledctl", "bin/ledctl"},
	{copy, "files/ledctl.cmd", "bin/ledctl.cmd"},
	{copy, "files/start_erl.cmd", "bin/start_erl.cmd"},
	{copy, "files/install_upgrade.escript", "bin/install_upgrade.escript"},
	{copy, "files/sys.config", "releases/\{\{rel_vsn\}\}/sys.config"},
	{copy, "files/vm.args", "releases/\{\{rel_vsn\}\}/vm.args"}
]}.
EOF
popd

cat > rebar.config << EOF
{lib_dirs, ["deps"]}.
{sub_dirs, ["rel"]}.
EOF

cat > Makefile << EOF
default: compile
compile:
	./rebar compile
	@echo -e '\nNow launch with "./launch.sh"'
release:
	./rebar compile generate
	@echo -e '\nNow grab release in "rel/ledctl"'
clean:
	rm -rf temp ebin deps rebar rel launch.sh
EOF

echo 'Run "make"'
