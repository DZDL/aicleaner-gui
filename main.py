import sys
import os

# IMPORT MODULES
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, QObject, QThread

from myWorkers.generalWorkers import WorkerBashCommand

PATH_CORE_BACKEND = 'backend/'
COMMAND_GIT_CLONE_CORE_BACKEND = 'git clone https://github.com/DZDL/aicleaner '+PATH_CORE_BACKEND
COMMAND_RUN_CORE_BACKEND = 'cd '+PATH_CORE_BACKEND +' && python3 main.py ' + " && cd .."

# Main Window Class
class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    # Static Info
    # staticUser = "user"
    # staticPass = "pass"

    # Signals To Send Data
    signalButtonInstall = Signal(bool)
    signalInstalledCoreBackend=Signal(bool)

    signalButtonRunCore=Signal(bool)
    signalCoreBackendRunning=Signal(bool)

    
    # -----------------------------------------------
    # HANDLERS OF FRONTEND FUNCTIONS
    # -----------------------------------------------
    # Function To Check and Start Install Core Backend
    @Slot()
    def installCoreBackend(self):
        """
        Code that execute when btnInstall is clicked
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')
        # emit signal of task started
        self.signalButtonInstall.emit(True)
        # Clone the repository
        if not os.path.isdir(PATH_CORE_BACKEND):
            os.mkdir(PATH_CORE_BACKEND)
            self.runFunctionInstallCoreBackend()
        else:
            print(f'[{nameOfFile}][{nameOfFunction}] Path {PATH_CORE_BACKEND} already exist')
            self.runFunctionInstallCoreBackendFinished() # Force finish

        print(f'[{nameOfFile}][{nameOfFunction}] Finished')


    @Slot()
    def runCoreBackend(self):
        """
        Function that runs Core Python
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')

        self.signalButtonRunCore.emit(True)

        self.runFunctionCoreBackend()

        self.signalCoreBackendRunning.emit(True)


        print(f'[{nameOfFile}][{nameOfFunction}] Finished')

    # -----------------------------------------------
    # THREADS SETUP
    # -----------------------------------------------
    def runFunctionInstallCoreBackend(self):
        """
        Script that run a class as Thread to don't freeze main app
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')
        # Step 1: Create worker
        # Step 2: Create a QThread object
        self.thread = QThread()
        # Step 3: Create a worker object
        self.worker = WorkerBashCommand()
        # Step 4: Move worker to the thread
        self.worker.moveToThread(self.thread)
        # Step 5: Connect signals and slots
        self.thread.started.connect(self.worker.runBashCommand(COMMAND_GIT_CLONE_CORE_BACKEND))
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.runFunctionInstallCoreBackendFinished)
        
        # Step 6: Start the thread
        self.thread.start()

        print(f'[{nameOfFile}][{nameOfFunction}] Finished')

    def runFunctionCoreBackend(self):
        """
        Script that run a class as Thread to don't freeze main app
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')
        # Step 1: Create worker
        # Step 2: Create a QThread object
        self.thread2 = QThread()
        # Step 3: Create a worker object
        self.worker2 = WorkerBashCommand()
        # Step 4: Move worker to the thread
        self.worker2.moveToThread(self.thread2)
        # Step 5: Connect signals and slots
        self.thread2.started.connect(self.worker2.runBashCommand(COMMAND_RUN_CORE_BACKEND))
        self.worker2.finished.connect(self.thread2.quit)
        self.worker2.finished.connect(self.worker2.deleteLater)
        self.thread2.finished.connect(self.runFunctionCoreBackendFinished)
        
        # Step 6: Start the thread
        self.thread2.start()

        print(f'[{nameOfFile}][{nameOfFunction}] Finished')



    # -----------------------------------------------
    # END OF THREADS
    # -----------------------------------------------
    @Slot()
    def runFunctionInstallCoreBackendFinished(self):
        """
        Function that executes when a Thread finish
        """
        # emit signal of task finished
        self.signalInstalledCoreBackend.emit(True) # Finish cloning core repo


    @Slot()
    def runFunctionCoreBackendFinished(self):
        """
        Function that executes when a Thread finish
        """
        # emit signal of task finished
        self.signalCoreBackendRunning.emit(True) # Finish cloning core repo

# INSTACE CLASS
if __name__ == "__main__":
    # Create app and engine
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    # Load QML File (Path like below)
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    # Check Exit App
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())