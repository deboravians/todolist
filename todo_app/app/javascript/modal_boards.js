function openDialog(dialog) {
  if (!dialog.open) dialog.showModal();
}

function closeDialog(dialog) {
  if (dialog.open) dialog.close();
}

document.addEventListener("click", (e) => {
  const createBtn = e.target.closest("[data-open-create-board]");
  if (createBtn) {
    e.preventDefault();
    openDialog(document.getElementById("modal-create-board"));
    return;
  }

  const editBtn = e.target.closest("[data-open-edit-board]");
  if (editBtn) {
    e.preventDefault();
    const id = editBtn.dataset.boardId;
    const title = editBtn.dataset.boardTitle;

    const dialog = document.getElementById("modal-edit-board");
    const form = document.getElementById("form-edit-board");
    const input = document.getElementById("edit-board-title");

    form.action = `/boards/${id}`;
    input.value = title || "";

    openDialog(dialog);
    input.focus();
    input.select();
    return;
  }

  const delBtn = e.target.closest("[data-open-delete-board]");
  if (delBtn) {
    e.preventDefault();
    const id = delBtn.dataset.boardId;
    const title = delBtn.dataset.boardTitle;

    const dialog = document.getElementById("modal-delete-board");
    const form = document.getElementById("form-delete-board");
    const label = document.getElementById("delete-board-title");

    form.action = `/boards/${id}`;
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

document.addEventListener("mousedown", (e) => {
  const dialog = e.target.closest("dialog");
  if (!dialog) return;

  const rect = dialog.getBoundingClientRect();
  const clickedInsideDialogContent =
    e.clientX >= rect.left &&
    e.clientX <= rect.right &&
    e.clientY >= rect.top &&
    e.clientY <= rect.bottom;

  if (!clickedInsideDialogContent) closeDialog(dialog);
});
