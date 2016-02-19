#!/usr/bin/env python

import logging
import sys
from optparse import OptionParser

try:
    from paramiko import AutoAddPolicy
    from paramiko.client import SSHClient
except:
    print "Please re-run after you have installed 'paramiko'"
    print "Example: easy_install paramiko"
    sys.exit(1)

DEFAULT_SSH_USER = "root"


def parse_args():
    parser = OptionParser(description='Run the appliance console on miq host')

    parser.add_option('--debug', action='store_true', 
        default=False, help='debug mode')

    parser.add_option('--miq_ip',
        default=None, help='miq IP Address/Hostname')

    parser.add_option('--ssh_user',
        default=DEFAULT_SSH_USER, help='miq SSH Username, defaults to "%s"' % (DEFAULT_SSH_USER))

    parser.add_option('--ssh_password',
        default=None, help='miq SSH Password')

    parser.add_option('--db_password',
        default=None, help='DB password')

    (opts, args) = parser.parse_args()

    for optname in ["miq_ip", "ssh_password", "ssh_user", "db_password"]:
        optvalue = getattr(opts, optname)
        if not optvalue:
            parser.print_help()
            parser.print_usage()
            print "Please re-run with an option specified for: '%s'" % (optname)
            sys.exit(1)

    return opts


def setup_logging(debug=False):
    if debug:
        loglevel = logging.DEBUG
    else:
        loglevel = logging.INFO
    logging.basicConfig(level=loglevel, format='%(asctime)s %(levelname)s %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')


def configure_cfme(ipaddr, ssh_username, ssh_password, region, db_password):
    cmd = "appliance_console_cli --region %s --internal --force-key -p %s" % (region, db_password)
    client = SSHClient()
    try:
        client.set_missing_host_key_policy(AutoAddPolicy()) 
        client.connect(ipaddr, username=ssh_username, password=ssh_password, allow_agent=False)
        print "Will run below command on host: '%s'" % (ipaddr)
        print cmd
        stdin, stdout, stderr = client.exec_command(cmd)
        status = stdout.channel.recv_exit_status()
        out = stdout.readlines()
        err = stderr.readlines()
        return status, out, err
    finally:
        client.close()

if __name__ == "__main__":

    opts = parse_args()
    debug = opts.debug
    setup_logging(debug)

    ipaddr = opts.miq_ip
    ssh_username = opts.ssh_user
    ssh_password = opts.ssh_password
    region = 1
    db_password = opts.db_password

    status, stdout, stderr = configure_cfme(ipaddr, ssh_username, ssh_password, region, db_password)
    
    if status == 0:
        print "Command output: '%s'" % (stdout)
    else:
        print "Error output: '%s'" % (stderr)

    sys.exit(status)
