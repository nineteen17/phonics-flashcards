import tkinter as tk
from tkinter import messagebox, ttk
import json
import os

JSON_FILE = "phonics.json"
DEFAULT_JSON_FILE = "default.json"


# ------------------------------------------------------
# STATUS SYSTEM
# ------------------------------------------------------
def get_status_icon(words):
    c = len(words)
    if c == 0:
        return "⚪"
    elif c < 8:
        return "🟡"
    return "🟢"


# ------------------------------------------------------
# LOAD / SAVE
# ------------------------------------------------------
def load_data():
    if os.path.exists(JSON_FILE):
        with open(JSON_FILE, "r") as f:
            return json.load(f)

    if os.path.exists(DEFAULT_JSON_FILE):
        with open(DEFAULT_JSON_FILE, "r") as f:
            return json.load(f)

    messagebox.showerror("Error", "No JSON files found")
    return []


def save_data(data):
    with open(JSON_FILE, "w") as f:
        json.dump(data, f, indent=2)


# ------------------------------------------------------
# MAIN APP
# ------------------------------------------------------
class PhonicsEditor:
    def __init__(self, root):
        self.root = root
        self.root.title("Phonics JSON Editor")
        self.root.geometry("1200x650")

        self.data = load_data()
        self.selected_index = None

        # ----------------------------------------------
        # macOS button styling
        # ----------------------------------------------
        style = ttk.Style()
        style.theme_use("clam")

        style.configure(
            "GreenButton.TButton",
            background="#4CAF50",
            foreground="white",
            padding=12,
            font=("Arial", 18),
        )

        style.map(
            "GreenButton.TButton",
            background=[("active", "#45A049")],
            foreground=[("active", "white")],
        )

        # ------------------------------------------------------
        # LEFT PANEL
        # ------------------------------------------------------
        left_frame = tk.Frame(root)
        left_frame.pack(side=tk.LEFT, fill=tk.Y, padx=15, pady=15)

        header = tk.Frame(left_frame)
        header.pack(fill=tk.X)

        tk.Label(header, text="Phonics Titles",
                 font=("Arial", 22, "bold")).pack(side=tk.LEFT)

        help_btn = tk.Button(header, text="❔", font=("Arial", 18), width=2,
                             command=self.show_help)
        help_btn.pack(side=tk.RIGHT, padx=5)

        self.tree = ttk.Treeview(left_frame, height=25)
        self.tree["columns"] = ("col1",)
        self.tree.column("#0", width=470, anchor="w")
        self.tree.column("col1", width=0, stretch=False)
        self.tree.pack(fill=tk.BOTH, expand=True)

        scrollbar = ttk.Scrollbar(left_frame, orient="vertical",
                                  command=self.tree.yview)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.tree.configure(yscroll=scrollbar.set)

        self.tree.tag_configure("bigfont", font=("Arial", 20))

        for i, item in enumerate(self.data):
            status = get_status_icon(item["words"])
            label = f"{status}   {item['group']} → {item['title']}"
            self.tree.insert("", "end", iid=i, text=label, tags=("bigfont",))

        self.tree.bind("<<TreeviewSelect>>", self.on_select)

        # ------------------------------------------------------
        # RIGHT PANEL
        # ------------------------------------------------------
        right_frame = tk.Frame(root)
        right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True,
                         padx=15, pady=15)

        self.title_label = tk.Label(right_frame, text="Select a title to edit",
                                    font=("Arial", 26))
        self.title_label.pack(pady=10)

        self.words_box = tk.Text(right_frame, height=18, width=60,
                                 font=("Arial", 22))
        self.words_box.pack(fill=tk.BOTH, expand=True)

        save_button = ttk.Button(right_frame, text="Save Words",
                                 style="GreenButton.TButton",
                                 command=self.save_words)
        save_button.pack(pady=20)

        # ------------------------------------------------------
        # KEYBOARD BINDINGS
        # ------------------------------------------------------
        # Tree-only navigation
        self.tree.bind("<Up>", self.tree_up)
        self.tree.bind("<Down>", self.tree_down)
        self.tree.bind("<Return>", self.tree_enter)

        # Global shortcuts
        root.bind_all("<Control-s>", self.key_save)
        root.bind_all("<Command-s>", self.key_save)
        root.bind_all("<Control-q>", self.key_quit)
        root.bind_all("<Command-q>", self.key_quit)

        # Disable built-in focus traversal
        root.bind_class("Tk", "<Tab>", lambda e: "break")
        root.bind_class("Tk", "<Shift-Tab>", lambda e: "break")

        # Custom TAB behavior
        root.bind_all("<Tab>", self.custom_tab)
        root.bind_all("<ISO_Left_Tab>", self.custom_shift_tab)
        root.bind_all("<Shift-Tab>", self.custom_shift_tab)

    # ------------------------------------------------------
    # HELP POPUP
    # ------------------------------------------------------
    def show_help(self):
        help_win = tk.Toplevel(self.root)
        help_win.title("Keyboard Shortcuts")
        help_win.geometry("420x340")

        tk.Label(help_win, text="Keyboard Shortcuts",
                 font=("Arial", 20, "bold")).pack(pady=10)

        txt = (
            "List Navigation:\n"
            "  ↑ / ↓          Move between titles\n"
            "  Enter          Open title & move to editor\n\n"
            "Saving:\n"
            "  Ctrl+S / Cmd+S  Save\n"
            "  Ctrl+Q / Cmd+Q  Quit\n\n"
            "Focus Movement:\n"
            "  Tab            Toggle list ⇄ editor\n"
            "  Shift+Tab      Always return to list\n"
        )

        tk.Label(help_win, text=txt, font=("Arial", 16), justify="left").pack(pady=10)

    # ------------------------------------------------------
    # CUSTOM TAB SYSTEM
    # ------------------------------------------------------
    def custom_tab(self, event):
        widget = self.root.focus_get()

        if widget == self.tree:
            self.root.after(1, lambda: self.words_box.focus())
            return "break"

        self.root.after(1, lambda: self.tree.focus())
        return "break"

    def custom_shift_tab(self, event):
        self.root.after(1, lambda: self.tree.focus())
        return "break"

    # ------------------------------------------------------
    # TREEVIEW NAVIGATION
    # ------------------------------------------------------
    def tree_up(self, event):
        sel = self.tree.selection()
        if not sel:
            self.tree.selection_set(0)
            return "break"

        idx = int(sel[0])
        if idx > 0:
            self.tree.selection_set(idx - 1)
            self.tree.focus(idx - 1)
            self.on_select(None)

        return "break"

    def tree_down(self, event):
        sel = self.tree.selection()
        if not sel:
            self.tree.selection_set(0)
            return "break"

        idx = int(sel[0])
        if idx < len(self.data) - 1:
            self.tree.selection_set(idx + 1)
            self.tree.focus(idx + 1)
            self.on_select(None)

        return "break"

    def tree_enter(self, event):
        self.on_select(None)
        self.words_box.focus()
        return "break"

    # ------------------------------------------------------
    # SELECTION HANDLER
    # ------------------------------------------------------
    def on_select(self, event):
        sel = self.tree.selection()
        if not sel:
            return

        self.selected_index = int(sel[0])
        entry = self.data[self.selected_index]

        self.title_label.config(
            text=f"Editing: {entry['group']} → {entry['title']}"
        )

        self.words_box.delete("1.0", tk.END)
        self.words_box.insert(tk.END, ", ".join(entry["words"]))

    # ------------------------------------------------------
    # SAVE / QUIT SHORTCUTS
    # ------------------------------------------------------
    def key_save(self, event):
        self.save_words()
        return "break"

    def key_quit(self, event):
        self.root.quit()
        return "break"

    # ------------------------------------------------------
    # SAVE WORDS (AUTO-ADVANCE FIXED)
    # ------------------------------------------------------
    def save_words(self):
        if self.selected_index is None:
            messagebox.showwarning("No selection", "Select a title first.")
            return

        entry = self.data[self.selected_index]
        new_text = self.words_box.get("1.0", tk.END).strip()

        if not new_text:
            messagebox.showinfo("Empty ignored", "Keeping existing words.")
            return

        new_words = [w.strip() for w in new_text.split(",") if w.strip()]

        # Confirm replacement
        if entry["words"] and new_words != entry["words"]:
            if not messagebox.askyesno(
                "Confirm Replace",
                f"Replace existing {len(entry['words'])} words?"
            ):
                return

        # Save
        entry["words"] = new_words
        save_data(self.data)

        # Update icon
        status = get_status_icon(new_words)
        new_label = f"{status}   {entry['group']} → {entry['title']}"
        self.tree.item(self.selected_index, text=new_label)

        # AUTO-ADVANCE IF COMPLETE
        if len(new_words) == 8:
            messagebox.showinfo("Complete",
                                "Marked complete (8 words). Moving to next.")

            next_index = self.selected_index + 1
            if next_index < len(self.data):
                self.tree.selection_set(next_index)
                self.tree.focus(next_index)
                self.on_select(None)

                # ⭐ FIX: small delay before focusing editor (PREVENTS ERROR BEEP)
                self.root.after(10, lambda: self.words_box.focus())

        else:
            messagebox.showinfo("Incomplete",
                                f"Still incomplete ({len(new_words)}/8).")
            self.words_box.focus()


# ------------------------------------------------------
# RUN
# ------------------------------------------------------
if __name__ == "__main__":
    root = tk.Tk()
    app = PhonicsEditor(root)
    root.mainloop()