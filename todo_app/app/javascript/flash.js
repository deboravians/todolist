document.addEventListener("turbo:load", () => {
  const flashes = document.querySelectorAll(".flash");
  
  flashes.forEach((flash) => {
    setTimeout(() => {
      flash.style.animation = "slideOut 0.3s ease-in forwards";
      
      setTimeout(() => {
        flash.remove();
      }, 300);
    }, 4000);
  });
});
