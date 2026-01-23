function openDialog(dialog) {
    if (!dialog.open) dialog.showModal();
}

function closeDialog(dialog) {
    if (dialog.open) dialog.close();
}

document.addEventListener("click", (e) => {
    const createBtn = e.target.closest("[data-open-create-list]");
    if (createBtn) {
        e.preventDefault();
        openDialog(document.getElementById("modal-create-list"));
        return;
    }

    const editBtn = e.target.closest("[data-open-edit-list]");
    if (editBtn) {
        e.preventDefault();
        const boardId = editBtn.dataset.boardId;
        const listId = editBtn.dataset.listId;
        const title = editBtn.dataset.listTitle;

        const dialog = document.getElementById("modal-edit-list");
        const form = document.getElementById("form-edit-list");
        const input = document.getElementById("edit-list-title");

        form.action = `/boards/${boardId}/lists/${listId}`;
        input.value = title || "";

        openDialog(dialog);
        input.focus();
        input.select();
        return;
    }

    const delBtn = e.target.closest("[data-open-delete-list]");
    if (delBtn) {
        e.preventDefault();
        const boardId = delBtn.dataset.boardId;
        const listId = delBtn.dataset.listId;
        const title = delBtn.dataset.listTitle;

        const dialog = document.getElementById("modal-delete-list");
        const form = document.getElementById("form-delete-list");
        const label = document.getElementById("delete-list-title");

        form.action = `/boards/${boardId}/lists/${listId}`;
        label.textContent = title || "";

        openDialog(dialog);
        return;
    }

    const closeBtn = e.target.closest("[data-close-modal]");
    if (closeBtn) {
        e.preventDefault();
        const dialog = closeBtn.closest("dialog");
        if (dialog) closeDialog(dialog);
    }
});

function closeDialogOnOutsideClick(event, closeFn = closeDialog) {
    const dialog = event.target.closest("dialog");
    if (!dialog) return;

    const rect = dialog.getBoundingClientRect();
    const clickedInDialog =
        event.clientX >= rect.left &&
        event.clientX <= rect.right &&
        event.clientY >= rect.top &&
        event.clientY <= rect.bottom;

    if (!clickedInDialog) closeFn(dialog);
}

document.addEventListener("mousedown", (e) => {
    closeDialogOnOutsideClick(e);
});
