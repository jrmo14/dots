import neovim
import os
import subprocess

@neovim.plugin
class BuildUpPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim

    @neovim.function('BuildUp')
    def buildUp(self, args):
        build_dirs = ['build', 'cmake-build-debug', 'cmake-build-release']

        final_output = ''
        visited = []

        # Subprocess doesn't seem to like empty strings in calls
        if args == '' or args == ['']:
            args = []
        elif isinstance(args, str):
            args = [args]

        while not os.getcwd()  == '/':
            contents = os.listdir()

            # Call our build systems
            if 'Makefile' in contents or 'makefile' in contents:
                final_output = subprocess.check_output(['make'] + args).decode()
                break
            elif 'build.ninja' in contents:
                final_output = subprocess.check_output(['ninja'] + args).decode()
                break

            # handle a few names for build dir
            idx = -1
            for i, d in enumerate(build_dirs):
                if d in contents:
                    idx = i
                    break

            # make sure we don't loop into the same directory over and over
            if os.getcwd() in visited:
                break
            visited.append(os.getcwd())

            if idx != -1:
                os.chdir(build_dirs[idx])
            else:
                os.chdir('..')

        if final_output == '':
            self.nvim.out_write('buildup> No output\n')
        else:
            for o in final_output.split('\n'):
                self.nvim.out_write(o+'\n')


if __name__ == "__main__":
    print('test')
    bup = BuildUpPlugin(None)
    bup.buildUp("")
