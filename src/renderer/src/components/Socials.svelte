<script>
  import Button from './Button.svelte'

  async function openExternal(url) {
    window.api.openExternal(await url)
  }
</script>

<div class="socials">
  <Button label="Website" onClick={() => openExternal(window.api.getConfig('WEBSITE_URL'))} />
  <Button label="Wiki" onClick={() => openExternal(window.api.getConfig('WIKI_URL'))} />
  <span></span>
  <Button label="Register" onClick={() => openExternal(window.api.getConfig('REGISTER_URL'))} />
  <Button label="Discord" onClick={() => openExternal(window.api.getConfig('DISCORD_INVITE'))} />
</div>

<style>
  .socials {
    display: flex;
    justify-content: space-between;
    gap: 40px;
    padding-top: 5px;
    padding-bottom: 15px;
    flex: 0 0 auto;
  }
  
  :global(.socials button:last-of-type) {
    margin-right: 20px;
    margin-left: -10px;
  }

  .socials span {
    flex-grow: 1;
  }
</style>
