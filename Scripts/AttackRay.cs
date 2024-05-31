using Godot;
using System;


public partial class AttackRay : RayCast3D
{
    // Properties of attack class
    [Export]
    public int Damage { get; set; } = 1; // Default damage value, can be set from editor

    // Enable/disable ray
    public void EnableRay()
    {
        this.Enabled = true;
    }

    public void DisableRay()
    {
        this.Enabled = false;
    }

    // Set/Get Damage on AttackRay
    public void SetDamage(int newDamage)
    {
        Damage = newDamage;
    }

    public int GetDamage()
    {
        return Damage;
    }

	/*
		Type Chekcing:
		'GetCollider' returns a 'GodotObject', which may not necessarily be a Node.
		Before Using 'GetNodeOrNull', cast 'collider' to 'Node' (as 'colliderNode').
		This checks if it is indeed a 'Node' object.
	*/

    // Call damage function on collided Object
    public void CallTakeDamage()
    {
		GD.Print("CallTakeDamage initiated");
        var collider = GetCollider();
        if (collider != null && collider is Node colliderNode) 
        {
			GD.Print("Collider not Null / colliderNode");
            var healthNode = colliderNode.GetNodeOrNull<Health>("Health");//'GetNodeOrNull<T>
            if (healthNode == null)
            {
                GD.Print("Health Object is Null");
				return;
            }
			else
			{
				GD.Print("HEalth Object is Real");
				healthNode.TakeDamage(Damage);
				return;
			}
        }
    }
}
