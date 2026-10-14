import sublime
import sublime_plugin
import subprocess
import os
from datetime import datetime

# 수동 커밋 진행 중일 때 자동 커밋을 막기 위한 플래그
_custom_commit_in_progress = False

class GitAutoCommitOnSave(sublime_plugin.EventListener):
    def on_post_save(self, view):
        global _custom_commit_in_progress
        if _custom_commit_in_progress:
            return

        file_path = view.file_name()
        if not file_path:
            return

        # 현재 저장된 파일이 속한 폴더 찾기
        folder_path = os.path.dirname(file_path)
        
        # 파일 경로를 역추적하여 가장 가까운 .git 폴더가 있는 루트 디렉토리 찾기
        git_root = folder_path
        while git_root and git_root != os.path.dirname(git_root):
            if os.path.exists(os.path.join(git_root, ".git")):
                break
            git_root = os.path.dirname(git_root)
            
        if not os.path.exists(os.path.join(git_root, ".git")):
            return

        self._silent_commit(file_path, git_root)

    def _silent_commit(self, file_path, git_root):
        startupinfo = self._get_startupinfo()

        try:
            subprocess.run(
                ["git", "add", "--", file_path],
                cwd=git_root,
                startupinfo=startupinfo,
                check=False
            )

            file_name = os.path.basename(file_path)
            time_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            commit_msg = f"{file_name}: {time_str}"
            
            subprocess.run(
                ["git", "commit", "-m", commit_msg],
                cwd=git_root,
                startupinfo=startupinfo,
                capture_output=True,
                text=True
            )
        except Exception:
            pass

    @staticmethod
    def _get_startupinfo():
        if os.name == "nt":
            startupinfo = subprocess.STARTUPINFO()
            startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
            return startupinfo
        return None

class GitCustomCommitCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        self.view.window().show_input_panel(
            "Commit Message:",
            "",
            self.on_done,
            None,
            None
        )

    def on_done(self, user_input):
        global _custom_commit_in_progress

        file_path = self.view.file_name()
        if not file_path:
            return

        folder_path = os.path.dirname(file_path)
        file_name = os.path.basename(file_path)

        # 현재 저장된 파일 경로를 역추적하여 가장 가까운 .git 및 .gitignore가 있는 폴더 찾기
        git_root = folder_path
        while git_root and git_root != os.path.dirname(git_root):
            if os.path.exists(os.path.join(git_root, ".git")):
                break
            git_root = os.path.dirname(git_root)

        # ---------------------------------------------------------
        # [.gitignore 자동 예외 규칙 추가 로직]
        # ---------------------------------------------------------
        gitignore_path = os.path.join(git_root, ".gitignore")
        rule = f"!{file_name}"

        if os.path.exists(gitignore_path):
            try:
                with open(gitignore_path, "r", encoding="utf-8") as f:
                    lines = [line.strip() for line in f.readlines()]
                
                # 중복 등록 방지: .gitignore 안에 !파일명 이 없을 때만 추가
                if rule not in lines:
                    with open(gitignore_path, "a", encoding="utf-8") as f:
                        f.write(f"\n{rule}")
            except Exception:
                pass
        # ---------------------------------------------------------

        user_msg = user_input.strip()
        if not user_msg:
            user_msg = "Manual Update"
            
        commit_msg = f"{file_name}: {user_msg}"
        startupinfo = GitAutoCommitOnSave._get_startupinfo()

        try:
            _custom_commit_in_progress = True
            self.view.run_command("save")

            subprocess.run(
                ["git", "add", "--", file_path],
                cwd=git_root,
                startupinfo=startupinfo,
                check=False
            )

            result = subprocess.run(
                ["git", "commit", "-m", commit_msg],
                cwd=git_root,
                startupinfo=startupinfo,
                capture_output=True,
                text=True
            )

            if result.returncode == 0:
                sublime.status_message(f"Commit successful: {commit_msg}")
            else:
                sublime.status_message("Nothing to commit or commit failed")
        except Exception as e:
            sublime.status_message(f"Commit failed: {e}")
        finally:
            _custom_commit_in_progress = False