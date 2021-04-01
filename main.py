import sys
import os

# IMPORT MODULES
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, QObject, QThread


PATH_BACKEND = 'backend/'
COMMAND_GIT_CLONE_BACKEND = 'git clone https://github.com/DZDL/aicleaner '+PATH_BACKEND
COMMAND_EXECUTE_MAIN_BACKEND = 'cd '+PATH_BACKEND + \
    ' && python3 main.py ' + " && cd .."


class WorkerInstallPythonBackend(QObject):
    """
    Class that allow multi-thread while executing commands
    """
    # https://realpython.com/python-pyqt-qthread/
    finished = Signal()
    logText = Signal(str)

    def runGitClonePythonBackend(self):
        """
        Long-running task.
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')

        log_git_clone_backend = os.popen(COMMAND_GIT_CLONE_BACKEND).read()
        self.logText.emit(str(log_git_clone_backend))
        # print('FAKE CLONING FINISHED')
        self.finished.emit()
        
        print(f'[{nameOfFile}][{nameOfFunction}] Finished')

# Main Window Classz


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    # Static Info
    staticUser = "wanderson"
    staticPass = "123456"

    # Signals To Send Data
    signalUser = Signal(str)
    signalPass = Signal(str)
    signalLogin = Signal(bool)
    signalInstall = Signal(bool)
    signalInstallLog = Signal(str)

    # Function To Check Login
    @Slot(str, str)
    def checkLogin(self, getUser, getPass):
        if(self.staticUser.lower() == getUser.lower() and self.staticPass == getPass):
            # Send User And Pass
            self.signalUser.emit("Username: " + getUser)
            self.signalPass.emit("Password: " + getPass)

            # Send Login Signal
            self.signalLogin.emit(True)
            print("Login passed!")
        else:
            self.signalLogin.emit(False)
            print("Login error!")

    # Function To Check and Start install Python Backend
    @Slot()
    def installPythonBackend(self):
        """
        Code that execute when btnInstall is clicked
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')
        # self.progressBarInstallPythonBackend.visible=True
        # self.ApplicationWindow.progressBarInstallPythonBackend=1.0
        self.signalInstall.emit(True)

        if not os.path.isdir(PATH_BACKEND):
            os.mkdir(PATH_BACKEND)

            self.runCommandInstallPythonBackend()
            # self.signalInstallLog.emit("Log: " + log_git_clone_backend)

            # log_execute_main_backend = os.popen(COMMAND_EXECUTE_MAIN_BACKEND).read()
        else:
            
            print(f'[{nameOfFile}][{nameOfFunction}] Path {PATH_BACKEND} already exist')

        print(f'[{nameOfFile}][{nameOfFunction}] Finished')

    def runCommandInstallPythonBackend(self):
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
        self.worker = WorkerInstallPythonBackend()
        # Step 4: Move worker to the thread
        self.worker.moveToThread(self.thread)
        # Step 5: Connect signals and slots
        self.thread.started.connect(self.worker.runGitClonePythonBackend)
        self.worker.finished.connect(self.thread.quit)
        self.worker.finished.connect(self.worker.deleteLater)
        self.thread.finished.connect(self.thread.deleteLater)
        self.worker.logText.connect(self.sendReportLogText)
        # Step 6: Start the thread
        self.thread.start()

        # Final resets
        # self.buttonInstall.setEnabled(False)
        # self.thread.finished.connect(
        #     lambda: self.buttonInstall.setEnabled(True)
        # )
        # self.thread.finished.connect(
        #     lambda: self.stepLabel.setText("Long-Running Step: 0")
        # )
        print(f'[{nameOfFile}][{nameOfFunction}] Finished')

    def sendReportLogText(self, mystr):
        """
        Send log from backend to frontend
        """
        nameOfFunction=sys._getframe().f_code.co_name
        nameOfFile=__file__
        print(f'[{nameOfFile}][{nameOfFunction}] Started')

        self.signalInstallLog.emit("ga")
        
        print(f'[{nameOfFile}][{nameOfFunction}] Finished')


# INSTACE CLASS
if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Get Context
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    # Load QML File
    engine.load(os.path.join(os.path.dirname(__file__), "qml/main.qml"))

    # Check Exit App
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
