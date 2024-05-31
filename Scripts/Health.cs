using Godot;
using System;



public partial class Health : Node
{
	//properties of Health Class
	[Export] 
	public int maxHealth = 3;
	public int currentHealth = 3;

	//Constructor
	public Health()
	{
		currentHealth = maxHealth;
	}

	//Take Damage
	public void TakeDamage(int amount)
	{
		currentHealth -= amount;
		if (currentHealth <= 0)
		{
			currentHealth = 0;
			GD.Print(GetInstanceId(), ": ", GetParent().Name, " is Dead.");
		}
		else
		{
			GD.Print(GetInstanceId(), ": ", GetParent().Name, " took ", amount, " damage!");
		}
	}

	//Heal Damage
	public void Heal(int amount)
	{
		currentHealth += amount;
		if (currentHealth > maxHealth)
		{
			currentHealth = maxHealth;
		}
		GD.Print(GetInstanceId(), ": ", GetParent().Name, " healed ", amount, " health!");
	}

	//Health Check
	public bool IsAlive()
	{
		return currentHealth > 0;
	}

	//Set new max health
	public void SetMaxHealth(int newMaxHealth)
	{
		maxHealth = newMaxHealth;
		GD.Print(GetInstanceId(), ": ", GetParent().Name, " new max health ", newMaxHealth, "!");
	}
}
