#!/usr/bin/env bash

# depencies
@import util/io.class util/IO.NAMEPARAMS

class __minimist__;
{
        public: app = initialize;
        public: app = get_args;
        public: app = eval_variable;
        public: app = type;
        public: app = get_arg;

        def: __minimist__::initialize()
        {
                global: model = "$@"

                var subs : "${model##*=}"
                var subs2 : ${model%%=*}
        }

        def: __minimist__::get_args()
        {
                __minimist__::initialize ${@}
        }

        def: __minimist__::eval_variable()
        {
                global: text = "$@"
                var __cc__ : ${text/[/}
                var __cc__ : ${__cc__/]/}
                __minimist__::get_args "${__cc__}"
                #eval "${subs2}=\"\${subs}\""
                printf -v "${subs2}" "%s" "${subs}"
        }

        def: system.validasi(){
                global: type = $(@return: ${@})
                if (eval "${type}" &> /dev/null); then
                        let Gta=1
                else
                        let Gta=0
                        return 0
                fi
        }

        def: __minimist__::type()
        {
                global: argument = "$@"
                system.validasi argument

                if ((Gta == 1)); then
                        var kembalikan : "variabel"
                else
                        #unset Gta
                        var kembalikan : "text"
                fi

                @return: kembalikan
        }

        def: __minimist__::get_arg()
        {
                #declare argument=$(@:return $@)
                declare argument="$@";
                declare tes1=${argument/]/}
                declare tes2=${tes1/[/}
                __minimist__::initialize "${tes2}"
                local efef="${subs2}=\"${subs}\""
                #echo "$efef"
                system.validasi efef
                if ((Gta == 1)); then
                        #echo "$tes2"
                        __minimist__::eval_variable "${tes2}"
                else
                        var dumny : ""
                fi
        }
}
