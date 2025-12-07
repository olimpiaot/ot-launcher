<script>
  import Button from './Button.svelte'
</script>

<Button className="close-button" label="✕" onClick={() => window.api.close()} />

<style>
  :global(.close-button) {
    position: fixed;
    right: 0px;
    top: 0px;
    width: 30px;
    height: 30px;
    font-size: 18px;
    font-weight: bold;
    z-index: 9999;
    padding: 0;
    min-width: 30px;
  }
  
  :global(.close-button:hover) {
    background-color: rgba(255, 0, 0, 0.2) !important;
  }
</style>
