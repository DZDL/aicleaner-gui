import sys
import os

# IMPORT MODULES
from PySide6.QtCore import QObject, Slot, Signal, QObject, QThread


class WorkerBashCommand(QObject):
    """
    Class that allow multi-thread while executing commands
    """
    # https://realpython.com/python-pyqt-qthread/
    # installingPythonBackend=Signal()
    finished = Signal()

    def runBashCommand(self,MY_COMMAND):
        """ 
        Long-running task.
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')

        log_git_clone_backend = os.popen(MY_COMMAND).read()
        # print('FAKE CLONING FINISHED......................................')

        self.finished.emit()
        
        print(f'[{nameOfFile}][{nameOfFunction}] Finished')
