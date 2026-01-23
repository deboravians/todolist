function openDialog(id) {
    const d = document.getElementById(id);
    if (d && !d.open) d.showModal();
}

function closeAllDialogs() {
    document.querySelectorAll("dialog.modal[open]").forEach(function (d) {
        d.close();
    });
}

document.addEventListener("click", (e) => {
    if (e.target.matches("[data-close-modal]")) {
        e.preventDefault();
        closeAllDialogs();
        return;
    }

    const createBtn = e.target.closest("[data-open-create-task]");
    if (createBtn) {
        e.preventDefault();
        const boardId = createBtn.dataset.boardId;
        const listId = createBtn.dataset.listId;

        const form = document.getElementById("form-create-task");
        form.action = `/boards/${boardId}/lists/${listId}/tasks`;

        form.reset();
        openDialog("modal-create-task");
        return;
    }

    const editBtn = e.target.closest("[data-open-edit-task]");
    if (editBtn) {
        e.preventDefault();
        const { boardId, listId, taskId, title, description, status, priority, dueDate } = editBtn.dataset;

        const form = document.getElementById("form-edit-task");
        form.action = `/boards/${boardId}/lists/${listId}/tasks/${taskId}`;

        document.getElementById("edit-task-title").value = title || "";
        document.getElementById("edit-task-description").value = description || "";
        document.getElementById("edit-task-status").value = status || "pending";
        document.getElementById("edit-task-priority").value = priority || "low";
        document.getElementById("edit-task-due-date").value = editBtn.dataset.dueDate || "";

        openDialog("modal-edit-task");
        return;
    }

    const delBtn = e.target.closest("[data-open-delete-task]");
    if (delBtn) {
        e.preventDefault();
        const { boardId, listId, taskId, title } = delBtn.dataset;

        document.getElementById("delete-task-title").textContent = title || "";

        const form = document.getElementById("form-delete-task");
        form.action = `/boards/${boardId}/lists/${listId}/tasks/${taskId}`;

        openDialog("modal-delete-task");
        return;
    }

    if (e.target.tagName === "DIALOG" && e.target.classList.contains("modal")) {
        e.target.close();
    }
});
