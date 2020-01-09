import signal
import sys
import subprocess
import os


def start_ssh():
    cmd = ["sudo", "service", "ssh", "start"]
    return subprocess.Popen(cmd)


def stop_ssh():
    cmd = ["sudo", "service", "ssh", "stop"]
    return subprocess.Popen(cmd)


def start_code_server():
    cmd = ["code-server", "--host", "0.0.0.0"]
    return subprocess.Popen(cmd)


def write_authorized_keys():
    key = os.getenv("SSH_KEY")
    if key:
        with open("/home/coder/.ssh/authorized_keys", "w") as fd:
            fd.write(key)


def main():
    write_authorized_keys()
    ssh_process = start_ssh()
    code_process = start_code_server()

    def exit_kill(sig, frame):
        stop_ssh()
        if sys.version_info >= (3, 7):
            code_process.kill()
        else:
            code_process.terminate()
    for sig in [signal.SIGINT, signal.SIGHUP, signal.SIGTERM]:
        signal.signal(sig, exit_kill)
    signal.pause()


if __name__ == "__main__":
    main()
