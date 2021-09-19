import Sortable from 'sortablejs';

export default {
  mounted() {
    let dragged;
    const hook = this;
    const selector = '#' + this.el.id;

    document.querySelectorAll('.dragarea').forEach((zone) => {
      new Sortable(zone, {
        animation: 0,
        delay: 50,
        delayOnTouchOnly: true,
        group: 'shared',
        draggable: '.draggable',
        ghostClass: 'draggable-ghost',
        onEnd: function(e) {
          hook.pushEventTo(selector, 'dropped', {
            id: e.item.id,
            index: e.newDraggableIndex
          })
        }
      });
    });
  }
};