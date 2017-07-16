-- Impregnates a creature

local args = {...}

function impregnate ()

  local victim = dfhack.gui.getSelectedUnit()
  local genes

  if (victim == nil) then
    return
  end

  genes = victim.appearance.genes:new()

  if (victim.pregnancy_timer > 0) then
    print('Already pregnant!')
    return
  end

  victim.pregnancy_genes = genes;
  victim.pregnancy_timer = 30;

  if (victim.pregnancy_spouse == 0) then
    victim.pregnancy_caste = 0;
  else
    victim.pregnancy_caste = 1;
  end

end

dfhack.with_suspend(impregnate)
